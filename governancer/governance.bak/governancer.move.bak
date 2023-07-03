module governancer::governance {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::vec_set::{Self, VecSet};
    use std::string::{Self, String};
    use sui::clock::{Self, Clock};
    use sui::transfer;
    use sui::event::emit;

    // ======== Constants =========
    const VERSION: u64 = 1;
    const SEVEN_DAYS_IN_MS: u64 = 604_800_000;

    // ======== Types =========
    struct AdminCap has key { id: UID }

    struct Voters has key {
        id: UID,
        group: VecSet<address>,
    }

    struct Proposal has key {
        id: UID,
        title: String,
        content_hash: String,
        end_time: u64,
        voted: VecSet<address>,
        approve: u64,
        deny: u64,
    }

    // ======== Events =========
    struct AddVoter has copy, drop {
        voter: address,
    }

    struct RemoveVoter has copy, drop {
        voter: address,
    }

    struct NewProposal has copy, drop {
        proposer: address,
        id: ID,
    }

    struct ApproveProposal has copy, drop {
        voter: address,
        id: ID,
    }

    struct DenyProposal has copy, drop {
        voter: address,
        id: ID,
    }

    // ======== Errors =========
    const ENotValidVoter: u64 = 0;
    const EAlreadyVoted: u64 = 1;
    const EOutDated: u64 = 2;

    fun init(ctx: &mut TxContext) {
        let sender: address = tx_context::sender(ctx);
        let admin_cap = AdminCap { id: object::new(ctx) };
        let voting_group = Voters {
            id: object::new(ctx),
            group: vec_set::singleton(sender),
        };

        transfer::transfer(admin_cap, sender);
        transfer::share_object(voting_group);
    }

    public entry fun propose(title: vector<u8>, content_hash: vector<u8>, clk: &Clock, ctx: &mut TxContext) {
        let proposal = Proposal {
            id: object::new(ctx),
            title: string::utf8(title),
            content_hash: string::utf8(content_hash),
            end_time: clock::timestamp_ms(clk) + SEVEN_DAYS_IN_MS,
            voted: vec_set::empty(),
            approve: 0,
            deny: 0,
        };
        emit(NewProposal {
            proposer: tx_context::sender(ctx),
            id: object::id(&proposal),
        });
        transfer::share_object(proposal);
    }

    public entry fun approve(proposal: &mut Proposal, voters: &Voters, clk: &Clock, ctx: &TxContext) {
        let voter: address = tx_context::sender(ctx);
        vote_check(proposal, voters, clk, voter);
        proposal.approve = proposal.approve + 1;
        emit( ApproveProposal {
            voter: voter,
            id: object::id(proposal),
        });
    }

    public entry fun deny(proposal: &mut Proposal, voters: &Voters, clk: &Clock, ctx: &TxContext) {
        let voter: address = tx_context::sender(ctx);
        vote_check(proposal, voters, clk, voter);
        proposal.deny = proposal.deny + 1;
        emit( DenyProposal {
            voter: voter,
            id: object::id(proposal),
        });
    }

    fun vote_check(proposal: &mut Proposal, voters: &Voters, clk: &Clock, voter: address) {
        assert!(clock::timestamp_ms(clk) < proposal.end_time, EOutDated);
        assert!(vec_set::contains(&voters.group, &voter), ENotValidVoter);
        assert!(!vec_set::contains(&proposal.voted, &voter), EAlreadyVoted);

        vec_set::insert(&mut proposal.voted, voter);
    }

    // === Admin-only functionality ===
    public entry fun add_voter(voters: &mut Voters, _: &AdminCap, voter: address) {
        vec_set::insert(&mut voters.group, voter);
        emit(AddVoter { voter: voter });
    }

    public entry fun remove_voter(voters: &mut Voters, _: &AdminCap, voter: address) {
        vec_set::remove(&mut voters.group, &voter);
        emit(RemoveVoter { voter: voter });
    }

}