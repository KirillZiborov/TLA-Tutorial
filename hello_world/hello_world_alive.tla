----------------------------- MODULE hello_world_alive ------------------------------
VARIABLES
    A_msgs,
    network,
    status,
    B_inbox
    
CONSTANT
    msgs

vars == <<A_msgs, network, status, B_inbox>> 

Init ==
    /\ A_msgs = {}
    /\ network = {}
    /\ status = "None"
    /\ B_inbox = {}

Send(m) == 
    /\ m \notin A_msgs
    /\ A_msgs' = A_msgs \union {m}
    /\ network' = network \union {m}
    /\ UNCHANGED <<status, B_inbox>>
    
NetworkDeliver == 
    /\ \E e \in network:
        /\ B_inbox' = B_inbox \union {e} 
        /\ network' = network \ {e}
    /\ UNCHANGED <<status, A_msgs>>

Receive == 
    /\ status' = IF B_inbox = msgs THEN "Ok" ELSE "None"
    /\ UNCHANGED <<network, B_inbox, A_msgs>>

Steps(m) == Send(m) \/ NetworkDeliver \/ Receive

Next == \/ \E m \in msgs: Steps(m)
        \/ UNCHANGED vars

Spec == Init 
        /\ [][Next]_vars
        /\ \A m \in msgs: WF_vars (Steps(m))
        
NothingUnexpectedInNetwork == \A e \in network: e \in A_msgs
     
EventuallyStatusIsOK == 
    LET IsStatusOk == status = "Ok"
    IN <>IsStatusOk
    
===============================================================================
