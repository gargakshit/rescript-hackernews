@react.component
let make = (~id: string) => {
  <div> {id->React.string} </div>
}
