# sound controller


audio = new AudioContext() # global lol

createSineWave = (audio, duration) ->
  osc = audio.createOscillator()
  osc.type = "sine"
  osc.start audio.currentTime

  # never stop if not passed in duration
  if duration
    osc.stop audio.currentTime + duration

  osc



chain = (soundNodes) ->
  len = soundNodes.length - 1
  for i in [0...len]
    soundNodes[i].connect soundNodes[i + 1]

# not pure. value is sideefects, returns nothing
rampDown = (audio, value, startValue, duration) ->
  value.setValueAtTime startValue, audio.currentTime
  value.exponentialRampToValueAtTime 0.01, audio.currentTime + duration

createAmplifier = (audio, startValue, duration) ->
  amplifier = audio.createGain()
  if duration
    rampDown audio, amplifier.gain, startValue, duration

  amplifier

# module.exports = (frequency, loudness=0.2) ->
#   # gets audio from global durp
#   return ->
#     duration = 5
#     sineWave = createSineWave audio, duration

#     sineWave.frequency.value = frequency

#     # chain [
#     #   sineWave,
#     #   createAmplifier(audio, loudness, duration),
#     #   audio.destination
#     # ]
#     chain [
#       sineWave,
#       createAmplifier audio, loudness
#       audio.destination
#     ]

globalSineWave = createSineWave audio, 880
globalGainNode = createAmplifier audio, 0.2

module.exports =
  changeFrequency: (frequency, loudness = 0.2) ->
    console.log 'frequency change', frequency
    globalSineWave.frequency.value = frequency
    globalGainNode.gain.value = loudness

  start: (frequency, loudness=0.2) ->
    chain [
      globalSineWave,
      globalGainNode,
      audio.destination
    ]

