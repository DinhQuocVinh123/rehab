String elbowUpperArmSvg({required String fill, required String stroke}) => '''
<svg viewBox="0 0 240 240" xmlns="http://www.w3.org/2000/svg">
  <g id="upper_arm">
    <path d="M 100,40 C 95,65 98,95 105,120 A 15 15 0 0 0 135,120 C 142,95 140,60 135,40 C 125,32 110,32 100,40 Z" fill="\$fill" stroke="\$stroke" stroke-width="4" stroke-linejoin="round"/>
    <path d="M 98,68 C 110,75 125,75 137,68" fill="none" stroke="\$stroke" stroke-width="2.5" stroke-linecap="round"/>
    <path d="M 118,72 C 115,90 110,110 105,120" fill="none" stroke="\$stroke" stroke-width="2.5" stroke-linecap="round"/>
    <circle cx="120" cy="120" r="15" fill="\$fill" stroke="\$stroke" stroke-width="4"/>
    <circle cx="120" cy="120" r="4" fill="\$stroke"/>
  </g>
</svg>
''';

String elbowForearmSvg({required String fill, required String stroke}) => '''
<svg viewBox="0 0 240 240" xmlns="http://www.w3.org/2000/svg">
  <g id="forearm_hand">
    <path d="M 120,105 C 140,98 170,105 190,115 C 200,113 208,115 210,124 C 210,128 198,128 195,126 C 170,136 140,138 120,135 A 15 15 0 0 1 120,105 Z" fill="\$fill" stroke="\$stroke" stroke-width="4" stroke-linejoin="round"/>
    <path d="M 125,118 C 145,120 165,116 182,114" fill="none" stroke="\$stroke" stroke-width="2.5" stroke-linecap="round"/>
    <path d="M 205,122 L 218,122 C 222,122 222,127 218,127 L 205,127 Z" fill="\$fill" stroke="\$stroke" stroke-width="3" stroke-linejoin="round"/>
    <path d="M 202,118 L 220,118 C 224,118 224,123 220,123 L 202,123 Z" fill="\$fill" stroke="\$stroke" stroke-width="3" stroke-linejoin="round"/>
    <path d="M 204,114 L 225,114 C 229,114 229,119 225,119 L 204,119 Z" fill="\$fill" stroke="\$stroke" stroke-width="3" stroke-linejoin="round"/>
    <path d="M 200,110 L 220,110 C 224,110 224,115 220,115 L 200,115 Z" fill="\$fill" stroke="\$stroke" stroke-width="3" stroke-linejoin="round"/>
    <path d="M 185,112 C 190,104 200,104 205,108 C 208,111 205,115 198,116 C 192,117 187,115 185,112 Z" fill="\$fill" stroke="\$stroke" stroke-width="3" stroke-linejoin="round"/>
  </g>
</svg>
''';