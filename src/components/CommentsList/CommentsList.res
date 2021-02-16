open Belt

module Comment = {
  @react.component
  let make = (~style: ReactDOM.style, ~comment: Story.commentPresent, ~text: string) => {
    let (collapsed, setCollapsed) = React.useState(_ => false)

    <div>
      <span className="commentheader" style onClick={_ => setCollapsed(v => !v)}>
        {collapsed ? <Chevron.Right /> : <Chevron.Down />}
        {` ${Time.fromNow(comment.time)} by ${comment.by}`->React.string}
      </span>
      {collapsed
        ? <div />
        : <div className="comment" dangerouslySetInnerHTML={{"__html": text->String.trim}} style />}
    </div>
  }
}

@react.component
let make = (~story: Story.storyWithComments) => {
  let rec renderComments = (ids: option<array<int>>) => renderCommentList(ids, 0)
  and renderComment = (id: int, depth: int) => {
    let comment = story.comments->Map.Int.get(id)
    let component = switch comment {
    | None => <div> {"Comment Unavilable"->React.string} </div>
    | Some(Story.CommentPresent(comment)) =>
      switch comment.text {
      | None => <div> {"Comment Unavilable x2"->React.string} </div>
      | Some(text) =>
        let calculatedMargin = (depth * 16)->Int.toString ++ "px"
        let style = ReactDOM.Style.make(~marginLeft=calculatedMargin, ())

        <div className="commentcontainer">
          <Comment style comment text /> {renderCommentList(comment.kids, depth + 1)}
        </div>
      }
    | Some(Story.CommentDeleted(comment)) =>
      <div> {`Comment Deleted, id: ${comment.id->Int.toString}`->React.string} </div>
    }

    <div key={`Comment_${id->Int.toString}`}> {component} </div>
  }
  and renderCommentList = (ids: option<array<int>>, depth: int) => {
    switch ids {
    | None => <div />
    | Some(ids) =>
      let comments = ids->Array.map(id => renderComment(id, depth))

      <div> {comments->React.array} </div>
    }
  }

  <div className="comments"> {renderComments(story.kids)} </div>
}
