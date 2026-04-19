## triggers.nim -- Graph property triggers -> WME assertion.
{.experimental: "strict_funcs".}
import events

type
  TriggerKind* {.pure.} = enum
    CycleDetected, ComponentSplit, DegreeThreshold

  Trigger* = object
    kind*: TriggerKind
    threshold*: int  ## For degree threshold
    node_id*: int    ## Relevant node

  CheckCycleFn* = proc(): bool {.raises: [].}
  CheckDegreeFn* = proc(node_id: int): int {.raises: [].}

proc check_cycle_trigger*(check_fn: CheckCycleFn): seq[GraphEvent] =
  if check_fn():
    result.add(GraphEvent(kind: GraphEventKind.EdgeAdded, label: "cycle_detected"))

proc check_degree_trigger*(node_id: int, threshold: int,
                           degree_fn: CheckDegreeFn): seq[GraphEvent] =
  let degree = degree_fn(node_id)
  if degree > threshold:
    result.add(GraphEvent(kind: GraphEventKind.NodeAdded, node_id: node_id,
                          label: "degree_exceeded_" & $threshold))
