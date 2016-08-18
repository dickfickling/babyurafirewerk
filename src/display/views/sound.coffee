# sound controller


audio = new AudioContext() # global lol


createWave = (audio, duration, type='sine') ->
  osc = audio.createOscillator()
  osc.type = type
  osc.start audio.currentTime
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
  value.exponentialRampToValueAtTime .001, audio.currentTime + duration

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


# like idk lolo
makeDistortionCurve = (amount = 50) ->
  nSamples = 44100
  curve = new Float32Array nSamples
  deg = Math.PI / 180
  for i in [0...nSamples]
    x = i * 2 / nSamples - 1
    curve[i] = ( 3 + amount ) * x * 20 * deg / (Math.PI + amount * Math.abs(x) )

  curve


globalSineWave = createWave audio, 880, type='sine'
globalSquareWave = createWave audio, 880, type='square'

globalGainNode = createAmplifier audio, 0.2

distortion = audio.createWaveShaper()

d           = new Date()
lastChanged = d.getTime()

module.exports =
  changeFrequency: (frequency, distortionAmount, loudness = 0.2) ->
    now = new Date().getTime()
    diff =  (now - lastChanged) / 1000

    console.log 'frequency change', frequency
    console.log 'distort amount:', distortionAmount

    globalGainNode.gain.value = loudness
    globalSineWave.frequency.value = frequency
    globalSquareWave.frequency.value = frequency * (5 / 8)
    distortion.curve = makeDistortionCurve distortionAmount

    unless diff < 1
      console.log 'ramping down volume'

      lastChanged = now
      # rampDown audio, globalGainNode.gain, loudness, 4


  start: (frequency, loudness=0.2) ->
    distortion.curve = makeDistortionCurve 400

    chain [
      globalSquareWave,
      globalGainNode,
      distortion,
      audio.destination
    ]

    chain [
      globalSineWave,
      globalGainNode,
      distortion,
      audio.destination
    ]

