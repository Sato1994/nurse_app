import { shallowMount } from '@vue/test-utils'

import TimeCard from '@/components/props/TimeCard.vue'

describe('TimeCard', () => {

  let initialProps = {
    partnerName: 'モチムギ',
    startTime: {
      year: 2022,
      month: 5,
      day: 1,
      hour: 20,
      minute: 0
    },
    finishTime: {
      year: 2022,
      month: 5,
      day: 1,
      hour: 20,
      minute: 0
    },
    color: 'warning'
  }

  it('partnerNameが渡されれば正しく表示される', () => {
    const wrapper = shallowMount(TimeCard, {
      propsData: initialProps
    })
    expect(wrapper.vm.partnerName).toBe('モチムギ')
  })

  it('start, finish のdayが同じの時のdisplayDay', () => {
    const wrapper = shallowMount(TimeCard, {
      propsData: initialProps
    })
    expect(wrapper.vm.displayDay).toBe('5/1')
  })

  it('start, finsih のdayが異なる時のdisplayDay', () => {
    initialProps.finishTime.day = 2

    const wrapper = shallowMount(TimeCard, {
      propsData: initialProps
    })
    expect(wrapper.vm.displayDay).toBe('5/1  -  5/2')
  })
})