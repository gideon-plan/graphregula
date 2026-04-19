## actions.nim -- Rule actions that modify graph.
{.experimental: "strict_funcs".}
import basis/code/choice

type
  GraphActionKind* {.pure.} = enum
    AddNode, RemoveNode, AddEdge, RemoveEdge

  GraphAction* = object
    kind*: GraphActionKind
    node_id*: int
    source_id*: int
    target_id*: int
    label*: string

  GraphMutateFn* = proc(action: GraphAction): Choice[bool] {.raises: [].}

proc add_node_action*(id: int, label: string = ""): GraphAction =
  GraphAction(kind: GraphActionKind.AddNode, node_id: id, label: label)

proc remove_node_action*(id: int): GraphAction =
  GraphAction(kind: GraphActionKind.RemoveNode, node_id: id)

proc add_edge_action*(source, target: int, label: string = ""): GraphAction =
  GraphAction(kind: GraphActionKind.AddEdge, source_id: source, target_id: target, label: label)

proc remove_edge_action*(source, target: int): GraphAction =
  GraphAction(kind: GraphActionKind.RemoveEdge, source_id: source, target_id: target)

proc execute*(action: GraphAction, mutate_fn: GraphMutateFn): Choice[bool] =
  mutate_fn(action)
