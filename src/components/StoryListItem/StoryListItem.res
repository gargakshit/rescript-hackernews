%%raw(`
import "./StoryListItem.css";
`)

open Belt

module CommentsButton = {
  @react.component
  let make = (~number: int) => {
    <div>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="20"
        height="20"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
        className="feather feather-message-square">
        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
      </svg>
      <span> {number->Int.toString->React.string} </span>
    </div>
  }
}

@react.component
let make = (~story: Story.story, ~index: int) => {
  let time = Time.fromNow(story.time)

  <div className="storyflex">
    <article className="storyitem">
      <a className="storyitem--link" href={story.url}>
        {(index + 1)->Int.toString->React.string}
        {". "->React.string}
        <span className="storyitem--link_title"> {story.title->React.string} </span>
      </a>
      <section className="storyitem--secondrow">
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
    <aside
      onClick={_ => RescriptReactRouter.push(`/comments/${story.id->Int.toString}`)}
      className="commentsbutton">
      <CommentsButton number={story.descendants} />
    </aside>
  </div>
}
