export default function (context) {
  if (!context.store.state.info.info.myid) {
    context.redirect('/search')
  }
}