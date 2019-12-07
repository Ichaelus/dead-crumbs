import { createConsumer } from '@rails/actioncable'

window.consumer = createConsumer('http://' + window.location.host + '/ws')
