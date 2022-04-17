export default function (context) {
  if (context.store.state.info.info.myid) {
    context.redirect(
      `/${context.store.state.info.me}/${context.store.state.info.info.myid}`
    )
  }
}