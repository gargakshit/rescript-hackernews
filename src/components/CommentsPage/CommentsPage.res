%%raw(`
import "./CommentsPage.css";
`)

open Belt

@react.component
let make = (~id: string) => {
  let (story, setStory) = React.useState(_ => None)
  let (time, setTime) = React.useState(_ => "")

  React.useEffect1(() => {
    Story.fetchStoryWithComments(id, callbackStory => {
      setStory(_ => Some(callbackStory))
      setTime(_ => Time.fromNow(callbackStory.time))
    })

    None
  }, [])

  switch story {
  | None => <div> {"Loading"->React.string} </div>
  | Some(story) =>
    <div>
      <a href={story.url} className="a"> <h2> {story.title->React.string} </h2> </a>
      <span className="secondline">
        {`${story.score->Int.toString} points | submitted ${time}`->React.string}
      </span>
      <CommentsList story />
    </div>
  }
}
