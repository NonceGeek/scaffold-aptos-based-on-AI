module my_addr::governancer {
    use std::signer;
    use std::string::{String};
    use std::vector;
    use aptos_framework::event::{Self, EventHandle};
    use aptos_framework::account;
        use std::table::{Self, Table};

    // ======== Constants =========
    const VERSION: u64 = 1;
    const SEVEN_DAYS_IN_MS: u64 = 604_800_000;

    const ENotValidVoter: u64 = 0;
    const EAlreadyVoted: u64 = 1;
    const EOutDated: u64 = 2;


    // ======== Struct =========

    struct Proposal has key, store {
        title: String,
        content_hash: String,
        end_time: u64,
        voted: vector<address>,
        approve: u64,
        deny: u64,
    }

    struct Voters has key {
        voters_list: vector<address>,
    }

    struct ProposalSet has key, store {
        proposal_map: Table<String, Proposal>,
        add_voter_events: EventHandle<AddVoterEvent>,
        remove_voter_events: EventHandle<RemoveVoterEvent>,
        new_proposal_events: EventHandle<NewProposalEvent>,
        approve_proposal_events: EventHandle<ApproveProposalEvent>,
        deny_proposal_events: EventHandle<DenyProposalEvent>,
    }

    // ======== Events =========

    struct AddVoterEvent has copy, drop, store {
        voter: address,
    }

    struct RemoveVoterEvent has copy, drop, store {
        voter: address,
    }

    struct NewProposalEvent has copy, drop, store {
        proposer: address,
        title: String,
        content_hash: String,
    }

    struct ApproveProposalEvent has copy, drop, store {
        voter: address,
        title: String,
        content_hash: String,
    }

    struct DenyProposalEvent has copy, drop, store {
        voter: address,
        title: String,
        content_hash: String,
    }

    // ======== Functions ========

    // This is only callable during publishing.
    fun init_module(account: &signer) {
        move_to(account, ProposalSet {
            proposal_map: table::new(), 
            add_voter_events: account::new_event_handle<AddVoterEvent>(account),
            remove_voter_events: account::new_event_handle<RemoveVoterEvent>(account),
            new_proposal_events: account::new_event_handle<NewProposalEvent>(account),
            approve_proposal_events: account::new_event_handle<ApproveProposalEvent>(account),
            deny_proposal_events: account::new_event_handle<DenyProposalEvent>(account),
        });

        move_to(account, Voters{
            voters_list: vector::empty<address>(),
        })
    }

    public entry fun proposal(acct: &signer, title: String, content_hash: String) acquires ProposalSet {
        // Create A proposal
        let proposal = Proposal {
            title: title,
            content_hash: content_hash,
            end_time: 0,
            voted: vector::empty<address>(),
            approve: 0,
            deny: 0,
        };
        // Emit the event after create proposal
        emit_create_proposal_event(signer::address_of(acct), title, content_hash);
        move_to<Proposal>(acct, proposal);
    }

    fun emit_create_proposal_event(voter: address, title: String, content_hash: String) acquires ProposalSet {
        let event = NewProposalEvent {
            proposer: voter,
            title: title,
            content_hash: content_hash,
        };
        event::emit_event(&mut borrow_global_mut<ProposalSet>(@my_addr).new_proposal_events, event);
    }

    // public entry fun add_voter(acct: &signer,  voter: address) acquires ProposalSet {
    //     // Emit the event before add voter
    //     emit_add_voter_event(signer::address_of(acct), voter);
    //     // Add voter
    //     let mut proposal_set = borrow_global_mut<ProposalSet>(@my_addr);
    //     let mut voters = proposal_set.voters;
    //     vector::push_back(&mut voters, voter);
    //     proposal_set.voters = voters;
    // }

}