open Belt

type state = {nextPage: int, loading: bool}
type action =
  | ChangePage({nextPage: int})
  | ChangeLoading({loading: bool})
  | StopLoadingAndNextPage
  | StartLoading

let initialState: state = {nextPage: 0, loading: true}

module Store = {
  let reducer = (state: state, action: action) => {
    switch action {
    | ChangePage({nextPage}) => {
        nextPage: nextPage,
        loading: state.loading,
      }
    | ChangeLoading({loading}) => {
        nextPage: state.nextPage,
        loading: loading,
      }
    | StopLoadingAndNextPage => {
        nextPage: state.nextPage + 1,
        loading: false,
      }
    | StartLoading => {
        nextPage: state.nextPage,
        loading: true,
      }
    }
  }
}

@react.component
let make = () => {
  let (content, setContent) = React.useState(_ => [])
  let (state, dispatch) = React.useReducer(Store.reducer, initialState)

  React.useEffect1(() => {
    Story.fetchStories(stories => {
      setContent(_ => stories)
      dispatch(StopLoadingAndNextPage)
    }, state.nextPage)
    None
  }, [])

  React.useEffect(() => {
    let distanceFromBottom = () => {
      let bodyClientHeight = %raw("document.body.clientHeight")
      let windowScrollY = %raw("window.scrollY")
      let windowInnerHeight = %raw("window.innerHeight")
      bodyClientHeight - (windowScrollY + windowInnerHeight)
    }

    let nearTheBottom = () => distanceFromBottom() < 100
    let scrollHandler = _ => {
      if nearTheBottom() && !state.loading && state.nextPage < 4 {
        dispatch(StartLoading)

        Story.fetchStories(stories => {
          setContent(content => content->Array.concat(stories))
          dispatch(StopLoadingAndNextPage)
        }, state.nextPage)
      }
    }

    Webapi.Dom.Window.addEventListener("scroll", scrollHandler, Webapi.Dom.window)

    Some(
      () => {
        Webapi.Dom.Window.removeEventListener("scroll", scrollHandler, Webapi.Dom.window)
      },
    )
  })

  let itemList =
    content->Array.mapWithIndex((index, story) =>
      <StoryListItem key={`story__${index->Int.toString}`} story index />
    )

  <div> {itemList->React.array} </div>
}
