open Belt

@react.component
let make = () => {
  let (content, setContent) = React.useState(_ => [])

  React.useEffect1(() => {
    Story.fetchStories(stories => {
      setContent(_ => stories)
    })

    None
  }, [])

  let itemList =
    content->Array.mapWithIndex((index, story) =>
      <StoryListItem key={`story__${index->Int.toString}`} story index />
    )

  <div> {itemList->React.array} </div>
}
