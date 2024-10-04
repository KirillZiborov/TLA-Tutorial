----------------------------- MODULE hello_world ------------------------------

EXTENDS Sequences

VARIABLES
    A_msgs,
    network,
    status,
    B_inbox

Init ==
    /\ A_msgs = {}
    /\ network = {}
    /\ status = "None"
    /\ B_inbox = <<>>

Send(m) == 
    /\ m \notin A_msgs
    /\ A_msgs' = A_msgs \union {m}
    /\ network' = network \union {m}
    /\ UNCHANGED <<status, B_inbox>>

NetworkLoss ==
    /\ \E e \in network : network' = network \ {e}
    /\ UNCHANGED <<status, B_inbox, A_msgs>>

NetworkDeliver == 
    /\ \E e \in network:
        /\ B_inbox' = B_inbox \o <<e>> 
        /\ network' = network \ {e}
    /\ UNCHANGED <<status, A_msgs>>

Receive == 
    /\ status' = IF B_inbox = <<"hello", "world">> THEN "Ok" ELSE "None"
    /\ UNCHANGED <<network, B_inbox, A_msgs>>

Next == \/ Send ("hello")
        \/ Send ("world")
        \/ NetworkLoss
        \/ NetworkDeliver
        \/ Receive

NothingUnexpectedInNetwork == \A e \in network: e \in A_msgs

TypeOK == /\ A_msgs \in SUBSET {"hello", "world"}
          /\ network \in SUBSET {"hello", "world"}
          /\ status \in {"Ok","None"}

(* EventuallyStatusIsOK == 
    LET IsStatusOk == status = "Ok"
    IN ~IsStatusOk
*)
===============================================================================
