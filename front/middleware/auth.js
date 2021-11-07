export default function (context) {
  if (!context.store.state.myInfo.myInfo.myid) {
    context.redirect('/')
  }
}