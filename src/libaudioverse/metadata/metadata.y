nodes:
 Lav_NODETYPE_GENERIC:
  suppress_implied_inherit: true
  properties:
   Lav_NODE_STATE: {name: state, type: int, default: Lav_NODESTATE_PLAYING, value_enum: Lav_NODE_STATES}
   Lav_NODE_AUTORESET: {name: autoreset, type: boolean, default: 1}
   Lav_NODE_MUL: {name: mul, type: float, default: 1.0, range: [-INFINITY, INFINITY]}
  doc_name: Generic Properties Common to All Nodes
 Lav_NODETYPE_SINE:
  properties:
   Lav_SINE_FREQUENCY: {name: frequency, type: float, default: 440.0, range: [0, INFINITY]}
  doc_name: Sine
 Lav_NODETYPE_SQUARE:
  properties:
   Lav_SQUARE_FREQUENCY: {name: frequency, type: float, default: 440.0, range: [0, INFINITY]}
   Lav_SQUARE_DUTY_CYCLE: {name: duty_cycle, type: float, default: 0.5, range: [0.0, 1.0]}
  doc_name: Square
 Lav_NODETYPE_NOISE:
  properties:
   Lav_NOISE_NOISE_TYPE: {name: noise_type, type: int, value_enum: Lav_NOISE_TYPES, default: Lav_NOISE_TYPE_WHITE}
   Lav_NOISE_SHOULD_NORMALIZE: {name: should_normalize, type: boolean, default: 0}
  doc_name: Noise Generator
 Lav_NODETYPE_FILE:
  properties:
   Lav_FILE_POSITION: {name: position, type: double, default: 0.0, range: dynamic}
   Lav_FILE_PITCH_BEND: {name: pitch_bend, type: float, default: 1.0, range: [0, INFINITY]}
   Lav_FILE_LOOPING: {name: looping, type: boolean, default: 0}
  events:
   Lav_FILE_END_EVENT: {name: end}
  doc_name: File
 Lav_NODETYPE_HRTF:
  properties:
   Lav_PANNER_AZIMUTH: {name: azimuth, type: float, default: 0.0, range: [-INFINITY, INFINITY]}
   Lav_PANNER_ELEVATION: {name: elevation, type: float, default: 0.0, range: [-90.0, 90.0]}
   Lav_PANNER_SHOULD_CROSSFADE: {name: should_crossfade, type: boolean, default: 1}
  doc_name: Hrtf
 Lav_NODETYPE_AMPLITUDE_PANNER:
  properties:
   Lav_PANNER_AZIMUTH: {name: azimuth, type: float, default: 0.0, range: [-INFINITY, INFINITY]}
   Lav_PANNER_ELEVATION: {name: elevation, type: float, default: 0.0, range: [-90.0, 90.0]}
   Lav_PANNER_SHOULD_CROSSFADE: {name: should_crossfade, type: boolean, default: 1}
   Lav_PANNER_CHANNEL_MAP: {name: channel_map, type: float_array, min_length: 2, max_length: MAX_INT, default: [-90, 90]}
   Lav_PANNER_SKIP_LFE: {name: skip_lfe, type: boolean, default: 1}
   Lav_PANNER_SKIP_CENTER: {name: skip_center, type: boolean, default: 1}
  extra_functions:
   Lav_amplitudePannerNodeConfigureStandardMap: {name: configure_standard_map}
  doc_name: Amplitude Panner
 Lav_NODETYPE_MULTIPANNER:
  properties:
   Lav_PANNER_AZIMUTH: {name: azimuth, type: float, default: 0.0, range: [-INFINITY, INFINITY]}
   Lav_PANNER_ELEVATION: {name: elevation, type: float, default: 0.0, range: [-90.0, 90.0]}
   Lav_PANNER_SHOULD_CROSSFADE: {name: should_crossfade, type: boolean, default: 1}
   Lav_PANNER_STRATEGY: {name: strategy, default: Lav_PANNING_STRATEGY_STEREO, type: int, value_enum: Lav_PANNING_STRATEGIES}
  doc_name: Multipanner
 Lav_NODETYPE_MIXER:
  properties:
   Lav_MIXER_MAX_PARENTS: {name: max_parents, type: int, default: 0, range: [0, MAX_INT]}
   Lav_MIXER_INPUTS_PER_PARENT: {name: inputs_per_parent, type: int, default: 0, range: [0, 0]}
  doc_name: Mixer
 Lav_NODETYPE_SIMPLE_ENVIRONMENT:
  properties:
   Lav_3D_POSITION: {name: position, type: float3, default: [0.0, 0.0, 0.0]}
   Lav_3D_ORIENTATION: {name: orientation, type: float6, default: [0.0, 0.0, -1.0, 0.0, 1.0, 0.0]}
   Lav_ENVIRONMENT_DEFAULT_DISTANCE_MODEL: {name: default_distance_model, default: Lav_DISTANCE_MODEL_LINEAR, type: int, value_enum: Lav_DISTANCE_MODELS}
   Lav_ENVIRONMENT_DEFAULT_MAX_DISTANCE: {name: default_max_distance, range: [0.0, INFINITY], type: float, default: 50.0}
   Lav_ENVIRONMENT_DEFAULT_SIZE: {name: default_size, type: float, range: [0.0, INFINITY], default: 0.0}
   Lav_ENVIRONMENT_DEFAULT_PANNER_STRATEGY: {name: default_panner_strategy, type: int, default: 1, value_enum: Lav_PANNING_STRATEGIES}
  doc_name: Simple Environment
 Lav_NODETYPE_SOURCE:
  properties:
   Lav_3D_POSITION: {name: position, type: float3, default: [0.0, 0.0, 0.0]}
   Lav_3D_ORIENTATION: {name: orientation, type: float6, default: [0.0, 0.0, -1.0, 0.0, 1.0, 0.0]}
   Lav_SOURCE_MAX_DISTANCE: {name: max_distance, type: float, default: 50.0, range: [0.0, INFINITY]}
   Lav_SOURCE_SIZE: {name: size, type: float, range: [0.0, INFINITY], default: 1.0}
   Lav_SOURCE_DISTANCE_MODEL: {name: distance_model, type: int, default: Lav_DISTANCE_MODEL_LINEAR, value_enum: Lav_DISTANCE_MODELS}
   Lav_SOURCE_PANNER_STRATEGY: {name: panner_strategy, default: Lav_PANNING_STRATEGY_STEREO, value_enum: Lav_PANNING_STRATEGIES, type: int}
  doc_name: Simple Source
 Lav_NODETYPE_DELAY:
  properties:
   Lav_DELAY_DELAY: {name: delay, type: float, default: 0.0, range: [0.0, 0.0]}
   Lav_DELAY_FEEDBACK: {name: feedback, type: float, default: 0.0, range: [0.0, 1.0]}
   Lav_DELAY_INTERPOLATION_TIME: {name: interpolation_time, type: float, default: 0.001, range: [0.001, INFINITY]}
   Lav_DELAY_DELAY_MAX: {name: delay_max, type: float, read_only: true}
  doc_name: Delay Line
 Lav_NODETYPE_PUSH:
  properties:
   Lav_PUSH_THRESHOLD: {name: threshold, type: float, range: [0.0, INFINITY], default: 0.03}
  events:
   Lav_PUSH_AUDIO_EVENT: {name: audio, multifiring_protection: true}
   Lav_PUSH_OUT_EVENT: {name: out}
  doc_name: Push Node
  extra_functions:
   Lav_pushNodeFeed: {name: feed}
 Lav_NODETYPE_BIQUAD:
  properties:
   Lav_BIQUAD_FILTER_TYPE: {name: filter_type, type: int, default: Lav_BIQUAD_TYPE_LOWPASS, value_enum: Lav_BIQUAD_TYPES}
   Lav_BIQUAD_Q: {name: q, type: float, range: [0.001, INFINITY], default: 0.7}
   Lav_BIQUAD_FREQUENCY: {name: frequency, type: float, range: [0, INFINITY], default: 2000.0}
   Lav_BIQUAD_DBGAIN: {name: dbgain, type: float, range: [-INFINITY, INFINITY], default: 0.0}
  doc_name: Biquad Filter
 Lav_NODETYPE_PULL:
  callbacks: [audio]
  doc_name: Pull Node
 Lav_NODETYPE_GRAPH_LISTENER:
  callbacks: [listening]
  doc_name: graph Listener
 Lav_NODETYPE_CUSTOM:
  callbacks: [processing]
  doc_name: Custom Node
 Lav_NODETYPE_RINGMOD:
  doc_name: Ring Modulator
 Lav_NODETYPE_FEEDBACK_DELAY_NETWORK:
  properties:
   Lav_FDN_INTERPOLATION_TIME: {name: interpolation_time, type: float, range:[0.001, INFINITY], default: 0.001}
   Lav_FDN_MAX_DELAY: {name: delay_max, type: float, read_only: true}
  extra_functions:
   Lav_feedbackDelayNetworkNodeSetFeedbackMatrix: {name: set_feedback_matrix}
   Lav_feedbackDelayNetworkNodeSetOutputGains: {name: set_output_gains}
   Lav_feedbackDelayNetworkNodeSetDelays: {name: set_delays}
   Lav_feedbackDelayNetworkNodeSetFeedbackDelayMatrix: {name: set_feedback_delay_matrix}
  doc_name: Feedback Delay Network
 Lav_NODETYPE_MULTIFILE:
  doc_name: Multifile Node
  extra_functions:
   Lav_multifileNodePlay: {name: play}
   Lav_multifileNodeStopAll: {name: stop_all}
 Lav_NODETYPE_IIR:
  doc_name: IIR Filter
  extra_functions:
   Lav_iirNodeSetCoefficients: {name: set_coefficients}
additional_important_enums:
 - Lav_LOGGING_LEVELS
 - Lav_PROPERTY_TYPES