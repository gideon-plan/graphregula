## events.nim -- Graph mutation events as regula WMEs.
{.experimental: "strict_funcs".}

type
  GraphEventKind* {.pure.} = enum
    NodeAdded, NodeRemoved, EdgeAdded, EdgeRemoved

  GraphEvent* = object
    kind*: GraphEventKind
    node_id*: int
    source_id*: int  ## For edge events
    target_id*: int  ## For edge events
    label*: string

  EventHandler* = proc(event: GraphEvent) {.raises: [].}

proc node_added*(id: int, label: string = ""): GraphEvent =
  GraphEvent(kind: GraphEventKind.NodeAdded, node_id: id, label: label)

proc node_removed*(id: int): GraphEvent =
  GraphEvent(kind: GraphEventKind.NodeRemoved, node_id: id)

proc edge_added*(source, target: int, label: string = ""): GraphEvent =
  GraphEvent(kind: GraphEventKind.EdgeAdded, source_id: source, target_id: target, label: label)

proc edge_removed*(source, target: int): GraphEvent =
  GraphEvent(kind: GraphEventKind.EdgeRemoved, source_id: source, target_id: target)
