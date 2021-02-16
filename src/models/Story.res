open Promise
open Json.Decode

type story = {
  by: string,
  id: int,
  title: string,
  url: string,
  score: int,
  descendants: int,
  time: int,
}

type stories = array<story>

@scope("JSON") @val
external parseJsonIntoStories: string => stories = "parse"

module Decoder = {
  let story = (json): story => {
    {
      by: field("by", string, json),
      id: field("id", int, json),
      title: field("title", string, json),
      url: field("url", string, json),
      score: field("score", int, json),
      descendants: field("descendants", int, json),
      time: field("time", int, json),
    }
  }

  let stories = (json): stories => array(story, json)
}

type fetchStoryCallback = stories => unit

let fetchStories = (callback: fetchStoryCallback): unit => {
  Fetch.fetch("https://serverless-api.hackernewsmobile.com/topstories-25-0.json")
  ->then(res => {
    Fetch.Response.json(res)
  })
  ->then(res => {
    let json = Decoder.stories(res)
    callback(json)

    resolve(res)
  })
  ->ignore
}
