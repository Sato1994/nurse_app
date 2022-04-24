import _id from '@/pages/rooms/_id.vue'
import Vuex from 'vuex'
import { createLocalVue, shallowMount } from '@vue/test-utils'

describe('_id', () => {
  const localVue = createLocalVue()
  localVue.use(Vuex)

  let wrapper

  let initialAgreement = {
    "id": null,
    "state": null,
    "startTime": {
      "year": null,
      "month": null,
      "day": null,
      "hour": null,
      "minute": null
    },
    "finishTime": {
      "year": null,
      "month": null,
      "day": null,
      "hour": null,
      "minute": null
    }
  }

  let initialRoom = {
    "id": 141,
    "partnerId": 44,
    "partnerName": "平成餅麦病院",
    "partnerMyid": "mochimugi",
    "state": "negotiating",
    "closed": "na",
    "startTime": {
      "year": 2022,
      "month": 5,
      "day": 13,
      "hour": 12,
      "minute": 0
    },
    "finishTime": {
      "year": 2022,
      "month": 5,
      "day": 14,
      "hour": 18,
      "minute": 0
    },
    "messages": []
  }

  // beforeEach(() => {
  // computed agreement store.gettersモック
  const agreementMock = jest.fn()
  agreementMock.mockReturnValue(initialAgreement)

  // computed room store.gettersモック
  const roomMock = jest.fn()
  roomMock.mockReturnValue(initialRoom)

  // computed agreement6HoursLater store getters モック
  const agreement6HoursLaterMock = jest.fn()
  agreement6HoursLaterMock.mockReturnValue(
    '4月27日6時'
  )

  // store 初期設定
  const store = new Vuex.Store({
    modules: {
      agreement: {
        namespaced: true,
        getters: {
          agreement: agreementMock,
          agreement6HoursLater: agreement6HoursLaterMock,
        }
      },
      room: {
        namespaced: true,
        getters: {
          room: roomMock
        }
      }
    }
  })

  // cookie モック
  const userCookie = jest.fn()
  userCookie.mockReturnValue('user')

  // マウント
  wrapper = shallowMount(_id, {
    localVue,
    store,
    mocks: {
      $cookies: {
        get: userCookie
      }
    }
  })
  // })

  // テスト
  it('TimeCardへ渡している値が期待しているもの', () => {
    expect(wrapper.vm.partnerLink).toEqual(`/host/${initialRoom.partnerMyid}`)
    expect(wrapper.vm.updateStateButton).toEqual(true)
    expect(wrapper.vm.updateStateButtonText).toEqual('この時間で同意')
    expect(wrapper.vm.updateTimeButton).toEqual(true)
    expect(wrapper.vm.editAgreementButton).toEqual(false)
    expect(wrapper.vm.cancellAgreementButton).toEqual(false)
    expect(wrapper.vm.cancellRoomButton).toEqual(true)
    expect(wrapper.vm.timeCardColor).toEqual('warning')

  })

  it('mapが描写されている', () => {
    expect(wrapper.find('.map').exists()).toBe(true)
  })

  it('rate入力欄が描写されていない', () => {
    expect(wrapper.find('.rateArea').exists()).toBe(false)
  })

})
