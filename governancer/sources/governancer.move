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

    const ENotAdmin: u64 = 3;


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
        titles: vector<String>, // all the titles of proposals.
        add_voter_events: EventHandle<AddVoterEvent>,
        reset_voter_events: EventHandle<ResetVoterEvent>,
        new_proposal_events: EventHandle<NewProposalEvent>,
        approve_proposal_events: EventHandle<ApproveProposalEvent>,
        deny_proposal_events: EventHandle<DenyProposalEvent>,
    }

    // ======== Events =========

    struct AddVoterEvent has copy, drop, store {
        voter: address,
    }

    struct ResetVoterEvent has copy, drop, store {
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
            titles: vector::empty<String>(),
            add_voter_events: account::new_event_handle<AddVoterEvent>(account),
            reset_voter_events: account::new_event_handle<ResetVoterEvent>(account),
            new_proposal_events: account::new_event_handle<NewProposalEvent>(account),
            approve_proposal_events: account::new_event_handle<ApproveProposalEvent>(account),
            deny_proposal_events: account::new_event_handle<DenyProposalEvent>(account),
        });

        move_to(account, Voters{
            voters_list: vector::empty<address>(),
        })
    }

    // === function about proposals ===

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
        // Table Change.
        let proposal_set = borrow_global_mut<ProposalSet>(@my_addr);
        table::add(&mut proposal_set.proposal_map, title, proposal);
        // add index.
        vector::push_back(&mut proposal_set.titles, title);
        // Emit the event after create proposal.
        emit_create_proposal_event(signer::address_of(acct), title, content_hash);
    }

    fun emit_create_proposal_event(voter: address, title: String, content_hash: String) acquires ProposalSet {
        let event = NewProposalEvent {
            proposer: voter,
            title: title,
            content_hash: content_hash,
        };
        event::emit_event(&mut borrow_global_mut<ProposalSet>(@my_addr).new_proposal_events, event);
    }

    public entry fun approve(acct: &signer, title: String) acquires ProposalSet {
        // TODO: Check if the acct is in Voters.
        // Table Change.
        let proposal_set = borrow_global_mut<ProposalSet>(@my_addr);
        let proposal = table::borrow_mut(&mut proposal_set.proposal_map, title);
        proposal.approve = proposal.approve + 1;
    }

    public entry fun deny(acct: &signer, title: String) acquires ProposalSet {
        // TODO: Check if the acct is in Voters.
        // Table Change.
        let proposal_set = borrow_global_mut<ProposalSet>(@my_addr);
        let proposal = table::borrow_mut(&mut proposal_set.proposal_map, title);
        proposal.deny = proposal.deny + 1;
    }


    // Impl view function to get proposal.
    #[view]
    public fun get_proposal_approve(title: String): u64 acquires ProposalSet {
        let proposal_set = borrow_global_mut<ProposalSet>(@my_addr);
        // table::borrow_mut(&mut proposal_set.proposal_map, title);
        let proposal = table::borrow(&mut proposal_set.proposal_map, title);
        proposal.approve
    }

    #[view]
    public fun get_proposal_deny(title: String): u64 acquires ProposalSet {
        let proposal_set = borrow_global_mut<ProposalSet>(@my_addr);
        // table::borrow_mut(&mut proposal_set.proposal_map, title);
        let proposal = table::borrow(&mut proposal_set.proposal_map, title);
        proposal.deny
    }

    // === function about voters ===

    public entry fun add_voter(acct: &signer, voter: address) acquires ProposalSet, Voters {
        assert!(signer::address_of(acct) == @my_addr, ENotAdmin);
        // Add voter
        let voters = borrow_global_mut<Voters>(@my_addr);
        vector::push_back(&mut voters.voters_list, voter);
        // Emit
        let event = AddVoterEvent{
            voter: voter,
        };

        event::emit_event(&mut borrow_global_mut<ProposalSet>(@my_addr).add_voter_events, event);

    }

    public entry fun reset_voter(acct: &signer,  voter: address) acquires ProposalSet, Voters {
        assert!(signer::address_of(acct) == @my_addr, ENotAdmin);
        // Add voter
        let voters = borrow_global_mut<Voters>(@my_addr);
        vector::destroy_empty(voters.voters_list);
        // Emit
        let event = ResetVoterEvent{};
        event::emit_event(&mut borrow_global_mut<ProposalSet>(@my_addr).reset_voter_events, event);
    }

    // public entry fun remove_voter(acct: &signer,  voter: address) acquires Voters {
    //     assert!(signer::address_of(acct) == @my_addr, ENotAdmin);
    //     // TODO: Remove voter
    //     let voters = borrow_global_mut<Voters>(@my_addr);
    //     // TODO: emit
    // }
}