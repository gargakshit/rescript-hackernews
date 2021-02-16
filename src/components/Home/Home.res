@react.component
let make = () => {
  let (content, setContent) = React.useState(_ => [])

  React.useEffect1(() => {
    Story.fetchStories(stories => {
      setContent(_ => stories)
    })

    None
  }, [])

  <div> {content->Array.length->Belt.Int.toString->React.string} </div>
}
