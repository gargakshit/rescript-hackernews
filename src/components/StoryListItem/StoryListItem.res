%%raw(`
import "./StoryListItem.css";
`)

open Belt

@react.component
let make = (~story: Story.story, ~index: int) => {
  let time = Time.fromNow(story.time)

  <article className="storyitem">
    <a className="storyitem--link" href={story.url}>
      {(index + 1)->Int.toString->React.string}
      {". "->React.string}
      <span className="storyitem--link_title"> {story.title->React.string} </span>
    </a>
    <section
      className="storyitem--secondrow"
      onClick={_ => RescriptReactRouter.push(`/comments/${story.id->Int.toString}`)}>
      <span>
        <span className="storyitem--secondrow_points">
          {story.score->Int.toString->React.string}
        </span>
        {" points"->React.string}
      </span>
      <span className="storyitem--secondrow_submitted">
        {`submitted ${time} by ${story.by}`->React.string}
      </span>
    </section>
  </article>
}
