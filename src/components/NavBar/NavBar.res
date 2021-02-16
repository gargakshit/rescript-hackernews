%%raw(`
import "./NavBar.css";
`)

module NavLink = {
  @react.component
  let make = (~title: string, ~url: string) => {
    <a onClick={_ => RescriptReactRouter.push(url)}> {title->React.string} </a>
  }
}

@react.component
let make = () => {
  <div className="navbar"> <NavLink title="ReScript Hacker News" url="/" /> </div>
}
