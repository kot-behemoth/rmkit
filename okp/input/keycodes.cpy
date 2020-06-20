namespace input:
  const char* get_key_str(int key):
    switch key:
      case 0: return "KEY_RESERVED"; break;
      case 1: return "KEY_ESC"; break;
      case 2: return "KEY_1"; break;
      case 3: return "KEY_2"; break;
      case 4: return "KEY_3"; break;
      case 5: return "KEY_4"; break;
      case 6: return "KEY_5"; break;
      case 7: return "KEY_6"; break;
      case 8: return "KEY_7"; break;
      case 9: return "KEY_8"; break;
      case 10: return "KEY_9"; break;
      case 11: return "KEY_0"; break;
      case 12: return "KEY_MINUS"; break;
      case 13: return "KEY_EQUAL"; break;
      case 14: return "KEY_BACKSPACE"; break;
      case 15: return "KEY_TAB"; break;
      case 16: return "KEY_Q"; break;
      case 17: return "KEY_W"; break;
      case 18: return "KEY_E"; break;
      case 19: return "KEY_R"; break;
      case 20: return "KEY_T"; break;
      case 21: return "KEY_Y"; break;
      case 22: return "KEY_U"; break;
      case 23: return "KEY_I"; break;
      case 24: return "KEY_O"; break;
      case 25: return "KEY_P"; break;
      case 26: return "KEY_LEFTBRACE"; break;
      case 27: return "KEY_RIGHTBRACE"; break;
      case 28: return "KEY_ENTER"; break;
      case 29: return "KEY_LEFTCTRL"; break;
      case 30: return "KEY_A"; break;
      case 31: return "KEY_S"; break;
      case 32: return "KEY_D"; break;
      case 33: return "KEY_F"; break;
      case 34: return "KEY_G"; break;
      case 35: return "KEY_H"; break;
      case 36: return "KEY_J"; break;
      case 37: return "KEY_K"; break;
      case 38: return "KEY_L"; break;
      case 39: return "KEY_SEMICOLON"; break;
      case 40: return "KEY_APOSTROPHE"; break;
      case 41: return "KEY_GRAVE"; break;
      case 42: return "KEY_LEFTSHIFT"; break;
      case 43: return "KEY_BACKSLASH"; break;
      case 44: return "KEY_Z"; break;
      case 45: return "KEY_X"; break;
      case 46: return "KEY_C"; break;
      case 47: return "KEY_V"; break;
      case 48: return "KEY_B"; break;
      case 49: return "KEY_N"; break;
      case 50: return "KEY_M"; break;
      case 51: return "KEY_COMMA"; break;
      case 52: return "KEY_DOT"; break;
      case 53: return "KEY_SLASH"; break;
      case 54: return "KEY_RIGHTSHIFT"; break;
      case 55: return "KEY_KPASTERISK"; break;
      case 56: return "KEY_LEFTALT"; break;
      case 57: return "KEY_SPACE"; break;
      case 58: return "KEY_CAPSLOCK"; break;
      case 59: return "KEY_F1"; break;
      case 60: return "KEY_F2"; break;
      case 61: return "KEY_F3"; break;
      case 62: return "KEY_F4"; break;
      case 63: return "KEY_F5"; break;
      case 64: return "KEY_F6"; break;
      case 65: return "KEY_F7"; break;
      case 66: return "KEY_F8"; break;
      case 67: return "KEY_F9"; break;
      case 68: return "KEY_F10"; break;
      case 69: return "KEY_NUMLOCK"; break;
      case 70: return "KEY_SCROLLLOCK"; break;
      case 71: return "KEY_KP7"; break;
      case 72: return "KEY_KP8"; break;
      case 73: return "KEY_KP9"; break;
      case 74: return "KEY_KPMINUS"; break;
      case 75: return "KEY_KP4"; break;
      case 76: return "KEY_KP5"; break;
      case 77: return "KEY_KP6"; break;
      case 78: return "KEY_KPPLUS"; break;
      case 79: return "KEY_KP1"; break;
      case 80: return "KEY_KP2"; break;
      case 81: return "KEY_KP3"; break;
      case 82: return "KEY_KP0"; break;
      case 83: return "KEY_KPDOT"; break;
      default: return "unknown key"; break;
