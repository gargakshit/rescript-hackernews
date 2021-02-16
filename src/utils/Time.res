open Belt

@val external currentTime: unit => int = "Date.now"

let fromNow = unixtime => {
  let delta = currentTime() / 1000 - unixtime
  if delta < 3600 {
    Int.toString(delta / 60) ++ " minutes ago"
  } else if delta < 86400 {
    Int.toString(delta / 3600) ++ " hours ago"
  } else {
    Int.toString(delta / 86400) ++ " days ago"
  }
}
