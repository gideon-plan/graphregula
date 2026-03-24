## events.nim -- Graph mutation events as regula WMEs.
{.experimental: "strict_funcs".}

type
  GraphEventKind* = enum
    geNodeAdded, geNodeRemoved, geEdgeAdded, geEdgeRemoved

  GraphEvent* = object
    kind*: GraphEventKind
    node_id*: int
    source_id*: int  ## For edge events
    target_id*: int  ## For edge events
    label*: string

  EventHandler* = proc(event: GraphEvent) {.raises: [].}

proc node_added*(id: int, label: string = ""): GraphEvent =
  GraphEvent(kind: geNodeAdded, node_id: id, label: label)

proc node_removed*(id: int): GraphEvent =
  GraphEvent(kind: geNodeRemoved, node_id: id)

proc edge_added*(source, target: int, label: string = ""): GraphEvent =
  GraphEvent(kind: geEdgeAdded, source_id: source, target_id: target, label: label)

proc edge_removed*(source, target: int): GraphEvent =
  GraphEvent(kind: geEdgeRemoved, source_id: source, target_id: target)
