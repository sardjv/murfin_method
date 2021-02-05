// converts e.g. 75 minutes to 1h 15m

const minutesHumanized = (mins_total) => {
  let hours = mins_total >= 60 ? Math.floor(mins_total / 60) : 0
  let minutes = Math.round(mins_total % 60)
  return (hours > 0 ? `${hours}h ` : '') + (minutes > 0 ? `${minutes}m` : '')
}

export default minutesHumanized;