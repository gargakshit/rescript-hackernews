open Belt
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

type commentPresent = {
  by: string,
  id: int,
  kids: option<array<int>>,
  parent: int,
  text: option<string>,
  time: int,
}

type commentDeleted = {id: int}

type comment =
  | CommentPresent(commentPresent)
  | CommentDeleted(commentDeleted)

type commentsMap = Map.Int.t<comment>

type storyWithComments = {
  by: string,
  descendants: int,
  id: int,
  kids: option<array<int>>,
  score: int,
  time: int,
  title: string,
  url: string,
  descendentIds: array<int>,
  comments: commentsMap,
}

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

  let idsArray = (json): array<int> => array(int, json)

  let getCommentId = comment =>
    switch comment {
    | CommentDeleted(c) => c.id
    | CommentPresent(c) => c.id
    }

  let comment = (json: Js.Json.t): comment => {
    let deletedMaybe = field("deleted", optional(bool), json)
    let deleted = switch deletedMaybe {
    | None => false
    | Some(v) => v == true
    }

    if deleted {
      CommentDeleted({
        id: field("id", int, json),
      })
    } else {
      CommentPresent({
        id: field("id", int, json),
        by: field("by", string, json),
        parent: field("parent", int, json),
        kids: field("kids", optional(idsArray), json),
        text: field("text", optional(string), json),
        time: field("time", int, json),
      })
    }
  }

  let commentsArray = (json): commentsMap => {
    array(comment, json)->Array.map(comment => (getCommentId(comment), comment))->Map.Int.fromArray
  }

  let storyWithComments = (json): storyWithComments => {
    by: field("by", string, json),
    descendants: field("descendants", int, json),
    descendentIds: field("descendentIds", idsArray, json),
    comments: field("comments", commentsArray, json),
    id: field("id", int, json),
    kids: field("kids", optional(idsArray), json),
    score: field("score", int, json),
    time: field("time", int, json),
    title: field("title", string, json),
    url: field("url", string, json),
  }
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

type fetchStoryWithCommentsCallback = storyWithComments => unit
let buildStoryWithCommentsUrl = (id: string) =>
  `https://serverless-api.hackernewsmobile.com/stories/${id}.json`
let fetchStoryWithComments = (id, callback: fetchStoryWithCommentsCallback) => {
  Fetch.fetch(buildStoryWithCommentsUrl(id))
  ->then(res => {
    Fetch.Response.json(res)
  })
  ->then(res => {
    let json = Decoder.storyWithComments(res)
    callback(json)

    resolve(res)
  })
  ->ignore
}
