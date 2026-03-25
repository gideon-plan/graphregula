## session.nim -- Combined graph + regula lifecycle.
{.experimental: "strict_funcs".}
import basis/code/choice, events, actions

type
  GraphRegulaSession* = object
    mutate_fn*: GraphMutateFn
    event_handler*: EventHandler
    events_fired*: int
    actions_executed*: int

proc new_session*(mutate_fn: GraphMutateFn, handler: EventHandler): GraphRegulaSession =
  GraphRegulaSession(mutate_fn: mutate_fn, event_handler: handler)

proc fire_event*(s: var GraphRegulaSession, event: GraphEvent) =
  s.event_handler(event)
  inc s.events_fired

proc execute_action*(s: var GraphRegulaSession, action: GraphAction): Choice[bool] =
  let r = execute(action, s.mutate_fn)
  if r.is_good: inc s.actions_executed
  r
