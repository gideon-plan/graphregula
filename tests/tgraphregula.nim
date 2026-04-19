{.experimental: "strict_funcs".}
import std/unittest
import graphregula

suite "events":
  test "create events":
    let e1 = node_added(1, "test")
    check e1.kind == GraphEventKind.NodeAdded
    check e1.node_id == 1
    let e2 = edge_added(1, 2, "connects")
    check e2.kind == GraphEventKind.EdgeAdded
    check e2.source_id == 1

suite "actions":
  test "create actions":
    let a = add_node_action(5, "new_node")
    check a.kind == GraphActionKind.AddNode
    check a.node_id == 5

suite "triggers":
  test "cycle trigger fires":
    let events = check_cycle_trigger(proc(): bool = true)
    check events.len == 1

  test "degree trigger fires":
    let events = check_degree_trigger(0, 3, proc(n: int): int = 5)
    check events.len == 1

suite "session":
  test "fire event and execute action":
    var fired = 0
    let handler: EventHandler = proc(e: GraphEvent) = inc fired
    let mutate: GraphMutateFn = proc(a: GraphAction): Result[void, BridgeError] {.raises: [].} =
      Result[void, BridgeError](ok: true)
    var s = new_session(mutate, handler)
    s.fire_event(node_added(1))
    check fired == 1
    check s.events_fired == 1
    let r = s.execute_action(add_node_action(2))
    check r.is_good
    check s.actions_executed == 1
