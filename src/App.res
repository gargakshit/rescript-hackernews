@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  let component = switch url.path {
  | list{} => <div> {"Home"->React.string} </div>
  | _ => <div> {"404"->React.string} </div>
  }

  <div className="content"> <NavBar /> <div className="content--internal"> {component} </div> </div>
}
