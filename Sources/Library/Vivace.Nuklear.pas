{==============================================================================
         _       ve'va'CHe
  __   _(_)_   ____ _  ___ ___ ™
  \ \ / / \ \ / / _` |/ __/ _ \
   \ V /| |\ V / (_| | (_|  __/
    \_/ |_| \_/ \__,_|\___\___|
                   game toolkit

 Copyright © 2020-21 tinyBigGAMES™ LLC
 All rights reserved.

 website: https://tinybiggames.com
 email  : support@tinybiggames.com

 LICENSE: zlib/libpng

 Vivace Game Toolkit is licensed under an unmodified zlib/libpng license,
 which is an OSI-certified, BSD-like license that allows static linking
 with closed source software:

 This software is provided "as-is", without any express or implied warranty.
 In no event will the authors be held liable for any damages arising from
 the use of this software.

 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software in
     a product, an acknowledgment in the product documentation would be
     appreciated but is not required.

  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.

  3. This notice may not be removed or altered from any source distribution.

============================================================================== }

unit Vivace.Nuklear;

{$I Vivace.Defines.inc }

interface

const
  NK_INCLUDE_DEFAULT_ALLOCATOR = 1;
  NK_UNDEFINED = (-1.0);
  NK_UTF_INVALID = $FFFD;
  NK_UTF_SIZE = 4;
  NK_INPUT_MAX = 16;
  NK_MAX_NUMBER_BUFFER = 64;
  NK_SCROLLBAR_HIDING_TIMEOUT = 4.0;
  NK_TEXTEDIT_UNDOSTATECOUNT = 99;
  NK_TEXTEDIT_UNDOCHARCOUNT = 999;
  NK_MAX_LAYOUT_ROW_TEMPLATE_COLUMNS = 16;
  NK_CHART_MAX_SLOT = 4;
  NK_WINDOW_MAX_NAME = 64;
  NK_BUTTON_BEHAVIOR_STACK_SIZE = 8;
  NK_FONT_STACK_SIZE = 8;
  NK_STYLE_ITEM_STACK_SIZE = 16;
  NK_FLOAT_STACK_SIZE = 32;
  NK_VECTOR_STACK_SIZE = 16;
  NK_FLAGS_STACK_SIZE = 32;
  NK_COLOR_STACK_SIZE = 32;
  NK_PI = 3.141592654;
  NK_MAX_FLOAT_PRECISION = 2;

  nk_false = 0;
  nk_true = 1;

  NK_UP = 0;
  NK_RIGHT = 1;
  NK_DOWN = 2;
  NK_LEFT = 3;

  NK_BUTTON_DEFAULT = 0;
  NK_BUTTON_REPEATER = 1;

  NK_MINIMIZED = 0;
  NK_MAXIMIZED = 1;

  NK_FIXED = 0;
  NK_MODIFIABLE = 1;

  NK_VERTICAL = 0;
  NK_HORIZONTAL = 1;

  NK_CHART_LINES = 0;
  NK_CHART_COLUMN = 1;
  NK_CHART_MAX = 2;

  NK_HIDDEN = 0;
  NK_SHOWN = 1;

  NK_CHART_HOVERING = 1;
  NK_CHART_CLICKED = 2;

  NK_RGB = 0;
  NK_RGBA = 1;

  NK_POPUP_STATIC = 0;
  NK_POPUP_DYNAMIC = 1;

  NK_DYNAMIC = 0;
  NK_STATIC = 1;

  NK_TREE_NODE = 0;
  NK_TREE_TAB = 1;

  NK_SYMBOL_NONE = 0;
  NK_SYMBOL_X = 1;
  NK_SYMBOL_UNDERSCORE = 2;
  NK_SYMBOL_CIRCLE_SOLID = 3;
  NK_SYMBOL_CIRCLE_OUTLINE = 4;
  NK_SYMBOL_RECT_SOLID = 5;
  NK_SYMBOL_RECT_OUTLINE = 6;
  NK_SYMBOL_TRIANGLE_UP = 7;
  NK_SYMBOL_TRIANGLE_DOWN = 8;
  NK_SYMBOL_TRIANGLE_LEFT = 9;
  NK_SYMBOL_TRIANGLE_RIGHT = 10;
  NK_SYMBOL_PLUS = 11;
  NK_SYMBOL_MINUS = 12;
  NK_SYMBOL_MAX = 13;

  NK_KEY_NONE = 0;
  NK_KEY_SHIFT = 1;
  NK_KEY_CTRL = 2;
  NK_KEY_DEL = 3;
  NK_KEY_ENTER = 4;
  NK_KEY_TAB = 5;
  NK_KEY_BACKSPACE = 6;
  NK_KEY_COPY = 7;
  NK_KEY_CUT = 8;
  NK_KEY_PASTE = 9;
  NK_KEY_UP = 10;
  NK_KEY_DOWN = 11;
  NK_KEY_LEFT = 12;
  NK_KEY_RIGHT = 13;
  NK_KEY_TEXT_INSERT_MODE = 14;
  NK_KEY_TEXT_REPLACE_MODE = 15;
  NK_KEY_TEXT_RESET_MODE = 16;
  NK_KEY_TEXT_LINE_START = 17;
  NK_KEY_TEXT_LINE_END = 18;
  NK_KEY_TEXT_START = 19;
  NK_KEY_TEXT_END = 20;
  NK_KEY_TEXT_UNDO = 21;
  NK_KEY_TEXT_REDO = 22;
  NK_KEY_TEXT_SELECT_ALL = 23;
  NK_KEY_TEXT_WORD_LEFT = 24;
  NK_KEY_TEXT_WORD_RIGHT = 25;
  NK_KEY_SCROLL_START = 26;
  NK_KEY_SCROLL_END = 27;
  NK_KEY_SCROLL_DOWN = 28;
  NK_KEY_SCROLL_UP = 29;
  NK_KEY_MAX = 30;

  NK_BUTTON_LEFT = 0;
  NK_BUTTON_MIDDLE = 1;
  NK_BUTTON_RIGHT = 2;
  NK_BUTTON_DOUBLE = 3;
  NK_BUTTON_MAX = 4;

  NK_ANTI_ALIASING_OFF = 0;
  NK_ANTI_ALIASING_ON = 1;

  NK_CONVERT_SUCCESS = 0;
  NK_CONVERT_INVALID_PARAM = 1;
  NK_CONVERT_COMMAND_BUFFER_FULL = 2;
  NK_CONVERT_VERTEX_BUFFER_FULL = 4;
  NK_CONVERT_ELEMENT_BUFFER_FULL = 8;

  NK_WINDOW_BORDER = 1;
  NK_WINDOW_MOVABLE = 2;
  NK_WINDOW_SCALABLE = 4;
  NK_WINDOW_CLOSABLE = 8;
  NK_WINDOW_MINIMIZABLE = 16;
  NK_WINDOW_NO_SCROLLBAR = 32;
  NK_WINDOW_TITLE = 64;
  NK_WINDOW_SCROLL_AUTO_HIDE = 128;
  NK_WINDOW_BACKGROUND = 256;
  NK_WINDOW_SCALE_LEFT = 512;
  NK_WINDOW_NO_INPUT = 1024;

  NK_WIDGET_INVALID = 0;
  NK_WIDGET_VALID = 1;
  NK_WIDGET_ROM = 2;

  NK_WIDGET_STATE_MODIFIED = 2;
  NK_WIDGET_STATE_INACTIVE = 4;
  NK_WIDGET_STATE_ENTERED = 8;
  NK_WIDGET_STATE_HOVER = 16;
  NK_WIDGET_STATE_ACTIVED = 32;
  NK_WIDGET_STATE_LEFT = 64;
  NK_WIDGET_STATE_HOVERED = 18;
  NK_WIDGET_STATE_ACTIVE = 34;

  NK_TEXT_ALIGN_LEFT = 1;
  NK_TEXT_ALIGN_CENTERED = 2;
  NK_TEXT_ALIGN_RIGHT = 4;
  NK_TEXT_ALIGN_TOP = 8;
  NK_TEXT_ALIGN_MIDDLE = 16;
  NK_TEXT_ALIGN_BOTTOM = 32;

  NK_TEXT_LEFT = 17;
  NK_TEXT_CENTERED = 18;
  NK_TEXT_RIGHT = 20;

  NK_EDIT_DEFAULT = 0;
  NK_EDIT_READ_ONLY = 1;
  NK_EDIT_AUTO_SELECT = 2;
  NK_EDIT_SIG_ENTER = 4;
  NK_EDIT_ALLOW_TAB = 8;
  NK_EDIT_NO_CURSOR = 16;
  NK_EDIT_SELECTABLE = 32;
  NK_EDIT_CLIPBOARD = 64;
  NK_EDIT_CTRL_ENTER_NEWLINE = 128;
  NK_EDIT_NO_HORIZONTAL_SCROLL = 256;
  NK_EDIT_ALWAYS_INSERT_MODE = 512;
  NK_EDIT_MULTILINE = 1024;
  NK_EDIT_GOTO_END_ON_ACTIVATE = 2048;

  NK_EDIT_SIMPLE = 512;
  NK_EDIT_FIELD = 608;
  NK_EDIT_BOX = 1640;
  NK_EDIT_EDITOR = 1128;

  NK_EDIT_ACTIVE = 1;
  NK_EDIT_INACTIVE = 2;
  NK_EDIT_ACTIVATED = 4;
  NK_EDIT_DEACTIVATED = 8;
  NK_EDIT_COMMITED = 16;

  NK_COLOR_TEXT = 0;
  NK_COLOR_WINDOW = 1;
  NK_COLOR_HEADER = 2;
  NK_COLOR_BORDER = 3;
  NK_COLOR_BUTTON = 4;
  NK_COLOR_BUTTON_HOVER = 5;
  NK_COLOR_BUTTON_ACTIVE = 6;
  NK_COLOR_TOGGLE = 7;
  NK_COLOR_TOGGLE_HOVER = 8;
  NK_COLOR_TOGGLE_CURSOR = 9;
  NK_COLOR_SELECT = 10;
  NK_COLOR_SELECT_ACTIVE = 11;
  NK_COLOR_SLIDER = 12;
  NK_COLOR_SLIDER_CURSOR = 13;
  NK_COLOR_SLIDER_CURSOR_HOVER = 14;
  NK_COLOR_SLIDER_CURSOR_ACTIVE = 15;
  NK_COLOR_PROPERTY = 16;
  NK_COLOR_EDIT = 17;
  NK_COLOR_EDIT_CURSOR = 18;
  NK_COLOR_COMBO = 19;
  NK_COLOR_CHART = 20;
  NK_COLOR_CHART_COLOR = 21;
  NK_COLOR_CHART_COLOR_HIGHLIGHT = 22;
  NK_COLOR_SCROLLBAR = 23;
  NK_COLOR_SCROLLBAR_CURSOR = 24;
  NK_COLOR_SCROLLBAR_CURSOR_HOVER = 25;
  NK_COLOR_SCROLLBAR_CURSOR_ACTIVE = 26;
  NK_COLOR_TAB_HEADER = 27;
  NK_COLOR_COUNT = 28;

  NK_CURSOR_ARROW = 0;
  NK_CURSOR_TEXT = 1;
  NK_CURSOR_MOVE = 2;
  NK_CURSOR_RESIZE_VERTICAL = 3;
  NK_CURSOR_RESIZE_HORIZONTAL = 4;
  NK_CURSOR_RESIZE_TOP_LEFT_DOWN_RIGHT = 5;
  NK_CURSOR_RESIZE_TOP_RIGHT_DOWN_LEFT = 6;
  NK_CURSOR_COUNT = 7;

  NK_BUFFER_FIXED = 0;
  NK_BUFFER_DYNAMIC = 1;

  NK_BUFFER_FRONT = 0;
  NK_BUFFER_BACK = 1;
  NK_BUFFER_MAX = 2;

  NK_TEXT_EDIT_SINGLE_LINE = 0;
  NK_TEXT_EDIT_MULTI_LINE = 1;

  NK_TEXT_EDIT_MODE_VIEW = 0;
  NK_TEXT_EDIT_MODE_INSERT = 1;
  NK_TEXT_EDIT_MODE_REPLACE = 2;

  _NK_COMMAND_NOP = 0;
  _NK_COMMAND_SCISSOR = 1;
  _NK_COMMAND_LINE = 2;
  _NK_COMMAND_CURVE = 3;
  _NK_COMMAND_RECT = 4;
  _NK_COMMAND_RECT_FILLED = 5;
  _NK_COMMAND_RECT_MULTI_COLOR = 6;
  _NK_COMMAND_CIRCLE = 7;
  _NK_COMMAND_CIRCLE_FILLED = 8;
  _NK_COMMAND_ARC = 9;
  _NK_COMMAND_ARC_FILLED = 10;
  _NK_COMMAND_TRIANGLE = 11;
  _NK_COMMAND_TRIANGLE_FILLED = 12;
  _NK_COMMAND_POLYGON = 13;
  _NK_COMMAND_POLYGON_FILLED = 14;
  _NK_COMMAND_POLYLINE = 15;
  _NK_COMMAND_TEXT = 16;
  _NK_COMMAND_IMAGE = 17;
  _NK_COMMAND_CUSTOM = 18;

  NK_STYLE_ITEM_COLOR = 0;
  NK_STYLE_ITEM_IMAGE = 1;

  NK_CLIPPING_OFF = 0;
  NK_CLIPPING_ON = 1;

  NK_HEADER_LEFT = 0;
  NK_HEADER_RIGHT = 1;

  NK_PANEL_NONE = 0;
  NK_PANEL_WINDOW = 1;
  NK_PANEL_GROUP = 2;
  NK_PANEL_POPUP = 4;
  NK_PANEL_CONTEXTUAL = 16;
  NK_PANEL_COMBO = 32;
  NK_PANEL_MENU = 64;
  NK_PANEL_TOOLTIP = 128;

  NK_PANEL_SET_NONBLOCK = 240;
  NK_PANEL_SET_POPUP = 244;
  NK_PANEL_SET_SUB = 246;

  NK_LAYOUT_DYNAMIC_FIXED = 0;
  NK_LAYOUT_DYNAMIC_ROW = 1;
  NK_LAYOUT_DYNAMIC_FREE = 2;
  NK_LAYOUT_DYNAMIC = 3;
  NK_LAYOUT_STATIC_FIXED = 4;
  NK_LAYOUT_STATIC_ROW = 5;
  NK_LAYOUT_STATIC_FREE = 6;
  NK_LAYOUT_STATIC = 7;
  NK_LAYOUT_TEMPLATE = 8;
  NK_LAYOUT_COUNT = 9;

  NK_WINDOW_PRIVATE = 2048;
  NK_WINDOW_DYNAMIC = 2048;
  NK_WINDOW_ROM = 4096;
  NK_WINDOW_NOT_INTERACTIVE = 5120;
  NK_WINDOW_HIDDEN = 8192;
  NK_WINDOW_CLOSED = 16384;
  NK_WINDOW_MINIMIZED = 32768;
  NK_WINDOW_REMOVE_ROM = 65536;


type
  _anonymous_type_1 = Integer;
  P_anonymous_type_1 = ^_anonymous_type_1;

  nk_heading = Integer;
  Pnk_heading = ^nk_heading;

  nk_button_behavior = Integer;
  Pnk_button_behavior = ^nk_button_behavior;

  nk_modify = Integer;
  Pnk_modify = ^nk_modify;

  nk_orientation = Integer;
  Pnk_orientation = ^nk_orientation;

  nk_collapse_states = Integer;
  Pnk_collapse_states = ^nk_collapse_states;

  nk_show_states = Integer;
  Pnk_show_states = ^nk_show_states;

  nk_chart_type = Integer;
  Pnk_chart_type = ^nk_chart_type;

  nk_chart_event = Integer;
  Pnk_chart_event = ^nk_chart_event;

  nk_color_format = Integer;
  Pnk_color_format = ^nk_color_format;

  nk_popup_type = Integer;
  Pnk_popup_type = ^nk_popup_type;

  nk_layout_format = Integer;
  Pnk_layout_format = ^nk_layout_format;

  nk_tree_type = Integer;
  Pnk_tree_type = ^nk_tree_type;

  nk_symbol_type = Integer;
  Pnk_symbol_type = ^nk_symbol_type;

  nk_keys = Integer;
  Pnk_keys = ^nk_keys;

  nk_buttons = Integer;
  Pnk_buttons = ^nk_buttons;

  nk_anti_aliasing = Integer;
  Pnk_anti_aliasing = ^nk_anti_aliasing;

  nk_convert_result = Integer;
  Pnk_convert_result = ^nk_convert_result;

  nk_panel_flags = Integer;
  Pnk_panel_flags = ^nk_panel_flags;

  nk_widget_layout_states = Integer;
  Pnk_widget_layout_states = ^nk_widget_layout_states;

  nk_widget_states = Integer;
  Pnk_widget_states = ^nk_widget_states;

  nk_text_align = Integer;
  Pnk_text_align = ^nk_text_align;

  nk_text_alignment = Integer;
  Pnk_text_alignment = ^nk_text_alignment;

  nk_edit_flags = Integer;
  Pnk_edit_flags = ^nk_edit_flags;

  nk_edit_types = Integer;
  Pnk_edit_types = ^nk_edit_types;

  nk_edit_events = Integer;
  Pnk_edit_events = ^nk_edit_events;

  nk_style_colors = Integer;
  Pnk_style_colors = ^nk_style_colors;

  nk_style_cursor = Integer;
  Pnk_style_cursor = ^nk_style_cursor;

  nk_allocation_type = Integer;
  Pnk_allocation_type = ^nk_allocation_type;

  nk_buffer_allocation_type = Integer;
  Pnk_buffer_allocation_type = ^nk_buffer_allocation_type;

  nk_text_edit_type = Integer;
  Pnk_text_edit_type = ^nk_text_edit_type;

  nk_text_edit_mode = Integer;
  Pnk_text_edit_mode = ^nk_text_edit_mode;

  nk_command_type = integer;
  Pnk_command_type = ^nk_command_type;

  nk_command_clipping = Integer;
  Pnk_command_clipping = ^nk_command_clipping;

  nk_style_item_type = Integer;
  Pnk_style_item_type = ^nk_style_item_type;

  nk_style_header_align = Integer;
  Pnk_style_header_align = ^nk_style_header_align;

  nk_panel_type = Integer;
  Pnk_panel_type = ^nk_panel_type;

  nk_panel_set = Integer;
  Pnk_panel_set = ^nk_panel_set;

  nk_panel_row_layout_type = Integer;
  Pnk_panel_row_layout_type = ^nk_panel_row_layout_type;

  nk_window_flags = Integer;
  Pnk_window_flags = ^nk_window_flags;

  PPUTF8Char = ^PUTF8Char;
  Pnk_draw_command = Pointer;
  PPnk_draw_command = ^Pnk_draw_command;
  Pnk_draw_list = Pointer;
  PPnk_draw_list = ^Pnk_draw_list;
  Pnk_draw_vertex_layout_element = Pointer;
  PPnk_draw_vertex_layout_element = ^Pnk_draw_vertex_layout_element;
  Pnk_style_slide = Pointer;
  PPnk_style_slide = ^Pnk_style_slide;
  Pnk_user_font_glyph = Pointer;
  PPnk_user_font_glyph = ^Pnk_user_font_glyph;
  Pnk_color = ^nk_color;
  Pnk_colorf = ^nk_colorf;
  Pnk_vec2 = ^nk_vec2;
  Pnk_vec2i = ^nk_vec2i;
  Pnk_rect = ^nk_rect;
  Pnk_recti = ^nk_recti;
  Pnk_image = ^nk_image;
  Pnk_cursor = ^nk_cursor;
  Pnk_scroll = ^nk_scroll;
  Pnk_allocator = ^nk_allocator;
  Pnk_draw_null_texture = ^nk_draw_null_texture;
  Pnk_convert_config = ^nk_convert_config;
  Pnk_list_view = ^nk_list_view;
  Pnk_user_font = ^nk_user_font;
  PPnk_user_font = ^Pnk_user_font;
  Pnk_memory_status = ^nk_memory_status;
  Pnk_buffer_marker = ^nk_buffer_marker;
  Pnk_memory = ^nk_memory;
  Pnk_buffer = ^nk_buffer;
  Pnk_str = ^nk_str;
  Pnk_clipboard = ^nk_clipboard;
  Pnk_text_undo_record = ^nk_text_undo_record;
  Pnk_text_undo_state = ^nk_text_undo_state;
  Pnk_text_edit = ^nk_text_edit;
  Pnk_command = ^nk_command;
  Pnk_command_scissor = ^nk_command_scissor;
  Pnk_command_line = ^nk_command_line;
  Pnk_command_curve = ^nk_command_curve;
  Pnk_command_rect = ^nk_command_rect;
  Pnk_command_rect_filled = ^nk_command_rect_filled;
  Pnk_command_rect_multi_color = ^nk_command_rect_multi_color;
  Pnk_command_triangle = ^nk_command_triangle;
  Pnk_command_triangle_filled = ^nk_command_triangle_filled;
  Pnk_command_circle = ^nk_command_circle;
  Pnk_command_circle_filled = ^nk_command_circle_filled;
  Pnk_command_arc = ^nk_command_arc;
  Pnk_command_arc_filled = ^nk_command_arc_filled;
  Pnk_command_polygon = ^nk_command_polygon;
  Pnk_command_polygon_filled = ^nk_command_polygon_filled;
  Pnk_command_polyline = ^nk_command_polyline;
  Pnk_command_image = ^nk_command_image;
  Pnk_command_custom = ^nk_command_custom;
  Pnk_command_text = ^nk_command_text;
  Pnk_command_buffer = ^nk_command_buffer;
  Pnk_mouse_button = ^nk_mouse_button;
  Pnk_mouse = ^nk_mouse;
  Pnk_key = ^nk_key;
  Pnk_keyboard = ^nk_keyboard;
  Pnk_input = ^nk_input;
  Pnk_style_item = ^nk_style_item;
  Pnk_style_text = ^nk_style_text;
  Pnk_style_button = ^nk_style_button;
  Pnk_style_toggle = ^nk_style_toggle;
  Pnk_style_selectable = ^nk_style_selectable;
  Pnk_style_slider = ^nk_style_slider;
  Pnk_style_progress = ^nk_style_progress;
  Pnk_style_scrollbar = ^nk_style_scrollbar;
  Pnk_style_edit = ^nk_style_edit;
  Pnk_style_property = ^nk_style_property;
  Pnk_style_chart = ^nk_style_chart;
  Pnk_style_combo = ^nk_style_combo;
  Pnk_style_tab = ^nk_style_tab;
  Pnk_style_window_header = ^nk_style_window_header;
  Pnk_style_window = ^nk_style_window;
  Pnk_style = ^nk_style;
  Pnk_chart_slot = ^nk_chart_slot;
  Pnk_chart = ^nk_chart;
  Pnk_row_layout = ^nk_row_layout;
  Pnk_popup_buffer = ^nk_popup_buffer;
  Pnk_menu_state = ^nk_menu_state;
  Pnk_panel = ^nk_panel;
  Pnk_popup_state = ^nk_popup_state;
  Pnk_edit_state = ^nk_edit_state;
  Pnk_property_state = ^nk_property_state;
  Pnk_window = ^nk_window;
  Pnk_config_stack_style_item_element = ^nk_config_stack_style_item_element;
  Pnk_config_stack_float_element = ^nk_config_stack_float_element;
  Pnk_config_stack_vec2_element = ^nk_config_stack_vec2_element;
  Pnk_config_stack_flags_element = ^nk_config_stack_flags_element;
  Pnk_config_stack_color_element = ^nk_config_stack_color_element;
  Pnk_config_stack_user_font_element = ^nk_config_stack_user_font_element;
  Pnk_config_stack_button_behavior_element = ^nk_config_stack_button_behavior_element;
  Pnk_config_stack_style_item = ^nk_config_stack_style_item;
  Pnk_config_stack_float = ^nk_config_stack_float;
  Pnk_config_stack_vec2 = ^nk_config_stack_vec2;
  Pnk_config_stack_flags = ^nk_config_stack_flags;
  Pnk_config_stack_color = ^nk_config_stack_color;
  Pnk_config_stack_user_font = ^nk_config_stack_user_font;
  Pnk_config_stack_button_behavior = ^nk_config_stack_button_behavior;
  Pnk_configuration_stacks = ^nk_configuration_stacks;
  Pnk_table = ^nk_table;
  Pnk_page_element = ^nk_page_element;
  Pnk_page = ^nk_page;
  Pnk_pool = ^nk_pool;
  Pnk_context = ^nk_context;

  nk_char = Shortint;
  nk_uchar = Byte;
  nk_byte = Byte;
  Pnk_byte = ^nk_byte;
  nk_short = Smallint;
  nk_ushort = Word;
  nk_int = Integer;
  nk_uint = Cardinal;
  Pnk_uint = ^nk_uint;
  //nk_size = UInt64;
  nk_size = cardinal;
  Pnk_size = ^nk_size;
  //nk_ptr = UInt64;
  nk_ptr = pointer;
  nk_hash = nk_uint;
  nk_flags = nk_uint;
  Pnk_flags = ^nk_flags;
  nk_rune = nk_uint;
  Pnk_rune = ^nk_rune;
  _dummy_array0 = array [0..0] of UTF8Char;
  _dummy_array1 = array [0..0] of UTF8Char;
  _dummy_array2 = array [0..0] of UTF8Char;
  _dummy_array3 = array [0..0] of UTF8Char;
  _dummy_array4 = array [0..0] of UTF8Char;
  _dummy_array5 = array [0..0] of UTF8Char;
  _dummy_array6 = array [0..0] of UTF8Char;
  _dummy_array7 = array [0..0] of UTF8Char;
  _dummy_array8 = array [0..0] of UTF8Char;

  nk_color = record
    r: nk_byte;
    g: nk_byte;
    b: nk_byte;
    a: nk_byte;
  end;

  nk_colorf = record
    r: Single;
    g: Single;
    b: Single;
    a: Single;
  end;

  nk_vec2 = record
    x: Single;
    y: Single;
  end;

  nk_vec2i = record
    x: Smallint;
    y: Smallint;
  end;

  nk_rect = record
    x: Single;
    y: Single;
    w: Single;
    h: Single;
  end;

  nk_recti = record
    x: Smallint;
    y: Smallint;
    w: Smallint;
    h: Smallint;
  end;

  nk_glyph = array [0..3] of UTF8Char;

  nk_handle = record
    case Integer of
      0: (ptr: Pointer);
      1: (id: Integer);
  end;

  nk_image = record
    handle: nk_handle;
    w: Word;
    h: Word;
    region: array [0..3] of Word;
  end;

  nk_cursor = record
    img: nk_image;
    size: nk_vec2;
    offset: nk_vec2;
  end;

  nk_scroll = record
    x: nk_uint;
    y: nk_uint;
  end;

  nk_plugin_alloc = function(p1: nk_handle; old: Pointer; p3: nk_size): Pointer; cdecl;
  nk_plugin_free = procedure(p1: nk_handle; old: Pointer); cdecl;
  nk_plugin_filter = function(const p1: Pnk_text_edit; unicode: nk_rune): Integer; cdecl;
  nk_plugin_paste = procedure(p1: nk_handle; p2: Pnk_text_edit); cdecl;
  nk_plugin_copy = procedure(p1: nk_handle; const p2: PUTF8Char; len: Integer); cdecl;

  nk_allocator = record
    userdata: nk_handle;
    alloc: nk_plugin_alloc;
    free: nk_plugin_free;
  end;

  nk_draw_null_texture = record
    texture: nk_handle;
    uv: nk_vec2;
  end;

  nk_convert_config = record
    global_alpha: Single;
    line_AA: nk_anti_aliasing;
    shape_AA: nk_anti_aliasing;
    circle_segment_count: Cardinal;
    arc_segment_count: Cardinal;
    curve_segment_count: Cardinal;
    null: nk_draw_null_texture;
    vertex_layout: Pnk_draw_vertex_layout_element;
    vertex_size: nk_size;
    vertex_alignment: nk_size;
  end;

  nk_list_view = record
    &begin: Integer;
    &end: Integer;
    count: Integer;
    total_height: Integer;
    ctx: Pnk_context;
    scroll_pointer: Pnk_uint;
    scroll_value: nk_uint;
  end;

  nk_text_width_f = function(p1: nk_handle; h: Single; const p3: PUTF8Char; len: Integer): Single; cdecl;
  nk_query_font_glyph_f = procedure(handle: nk_handle; font_height: Single; glyph: Pnk_user_font_glyph; codepoint: nk_rune; next_codepoint: nk_rune); cdecl;

  nk_user_font = record
    userdata: nk_handle;
    height: Single;
    width: nk_text_width_f;
  end;

  nk_memory_status = record
    memory: Pointer;
    &type: Cardinal;
    size: nk_size;
    allocated: nk_size;
    needed: nk_size;
    calls: nk_size;
  end;

  nk_buffer_marker = record
    active: Integer;
    offset: nk_size;
  end;

  nk_memory = record
    ptr: Pointer;
    size: nk_size;
  end;

  nk_buffer = record
    marker: array [0..1] of nk_buffer_marker;
    pool: nk_allocator;
    &type: nk_allocation_type;
    memory: nk_memory;
    grow_factor: Single;
    allocated: nk_size;
    needed: nk_size;
    calls: nk_size;
    size: nk_size;
  end;

  nk_str = record
    buffer: nk_buffer;
    len: Integer;
  end;

  nk_clipboard = record
    userdata: nk_handle;
    paste: nk_plugin_paste;
    copy: nk_plugin_copy;
  end;

  nk_text_undo_record = record
    where: Integer;
    insert_length: Smallint;
    delete_length: Smallint;
    char_storage: Smallint;
  end;

  nk_text_undo_state = record
    undo_rec: array [0..98] of nk_text_undo_record;
    undo_char: array [0..998] of nk_rune;
    undo_point: Smallint;
    redo_point: Smallint;
    undo_char_point: Smallint;
    redo_char_point: Smallint;
  end;

  nk_text_edit = record
    clip: nk_clipboard;
    &string: nk_str;
    filter: nk_plugin_filter;
    scrollbar: nk_vec2;
    cursor: Integer;
    select_start: Integer;
    select_end: Integer;
    mode: Byte;
    cursor_at_end_of_line: Byte;
    initialized: Byte;
    has_preferred_x: Byte;
    single_line: Byte;
    active: Byte;
    padding1: Byte;
    preferred_x: Single;
    undo: nk_text_undo_state;
  end;

  nk_command = record
    &type: nk_command_type;
    next: nk_size;
  end;

  nk_command_scissor = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
  end;

  nk_command_line = record
    header: nk_command;
    line_thickness: Word;
    &begin: nk_vec2i;
    &end: nk_vec2i;
    color: nk_color;
  end;

  nk_command_curve = record
    header: nk_command;
    line_thickness: Word;
    &begin: nk_vec2i;
    &end: nk_vec2i;
    ctrl: array [0..1] of nk_vec2i;
    color: nk_color;
  end;

  nk_command_rect = record
    header: nk_command;
    rounding: Word;
    line_thickness: Word;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    color: nk_color;
  end;

  nk_command_rect_filled = record
    header: nk_command;
    rounding: Word;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    color: nk_color;
  end;

  nk_command_rect_multi_color = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    left: nk_color;
    top: nk_color;
    bottom: nk_color;
    right: nk_color;
  end;

  nk_command_triangle = record
    header: nk_command;
    line_thickness: Word;
    a: nk_vec2i;
    b: nk_vec2i;
    c: nk_vec2i;
    color: nk_color;
  end;

  nk_command_triangle_filled = record
    header: nk_command;
    a: nk_vec2i;
    b: nk_vec2i;
    c: nk_vec2i;
    color: nk_color;
  end;

  nk_command_circle = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    line_thickness: Word;
    w: Word;
    h: Word;
    color: nk_color;
  end;

  nk_command_circle_filled = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    color: nk_color;
  end;

  nk_command_arc = record
    header: nk_command;
    cx: Smallint;
    cy: Smallint;
    r: Word;
    line_thickness: Word;
    a: array [0..1] of Single;
    color: nk_color;
  end;

  nk_command_arc_filled = record
    header: nk_command;
    cx: Smallint;
    cy: Smallint;
    r: Word;
    a: array [0..1] of Single;
    color: nk_color;
  end;

  nk_command_polygon = record
    header: nk_command;
    color: nk_color;
    line_thickness: Word;
    point_count: Word;
    points: array [0..0] of nk_vec2i;
  end;

  nk_command_polygon_filled = record
    header: nk_command;
    color: nk_color;
    point_count: Word;
    points: array [0..0] of nk_vec2i;
  end;

  nk_command_polyline = record
    header: nk_command;
    color: nk_color;
    line_thickness: Word;
    point_count: Word;
    points: array [0..0] of nk_vec2i;
  end;

  nk_command_image = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    img: nk_image;
    col: nk_color;
  end;

  nk_command_custom_callback = procedure(canvas: Pointer; x: Smallint; y: Smallint; w: Word; h: Word; callback_data: nk_handle); cdecl;

  nk_command_custom = record
    header: nk_command;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    callback_data: nk_handle;
    callback: nk_command_custom_callback;
  end;

  nk_command_text = record
    header: nk_command;
    font: Pnk_user_font;
    background: nk_color;
    foreground: nk_color;
    x: Smallint;
    y: Smallint;
    w: Word;
    h: Word;
    height: Single;
    length: Integer;
    &string: array [0..0] of UTF8Char;
  end;

  nk_command_buffer = record
    base: Pnk_buffer;
    clip: nk_rect;
    use_clipping: Integer;
    userdata: nk_handle;
    &begin: nk_size;
    &end: nk_size;
    last: nk_size;
  end;

  nk_mouse_button = record
    down: Integer;
    clicked: Cardinal;
    clicked_pos: nk_vec2;
  end;

  nk_mouse = record
    buttons: array [0..3] of nk_mouse_button;
    pos: nk_vec2;
    prev: nk_vec2;
    delta: nk_vec2;
    scroll_delta: nk_vec2;
    grab: Byte;
    grabbed: Byte;
    ungrab: Byte;
  end;

  nk_key = record
    down: Integer;
    clicked: Cardinal;
  end;

  nk_keyboard = record
    keys: array [0..29] of nk_key;
    text: array [0..15] of UTF8Char;
    text_len: Integer;
  end;

  nk_input = record
    keyboard: nk_keyboard;
    mouse: nk_mouse;
  end;

  nk_style_item_data = record
    case Integer of
      0: (image: nk_image);
      1: (color: nk_color);
  end;

  nk_style_item = record
    &type: nk_style_item_type;
    data: nk_style_item_data;
  end;

  nk_style_text = record
    color: nk_color;
    padding: nk_vec2;
  end;

  nk_style_button = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    text_background: nk_color;
    text_normal: nk_color;
    text_hover: nk_color;
    text_active: nk_color;
    text_alignment: nk_flags;
    border: Single;
    rounding: Single;
    padding: nk_vec2;
    image_padding: nk_vec2;
    touch_padding: nk_vec2;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; userdata: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; userdata: nk_handle); cdecl;
  end;

  nk_style_toggle = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    cursor_normal: nk_style_item;
    cursor_hover: nk_style_item;
    text_normal: nk_color;
    text_hover: nk_color;
    text_active: nk_color;
    text_background: nk_color;
    text_alignment: nk_flags;
    padding: nk_vec2;
    touch_padding: nk_vec2;
    spacing: Single;
    border: Single;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_selectable = record
    normal: nk_style_item;
    hover: nk_style_item;
    pressed: nk_style_item;
    normal_active: nk_style_item;
    hover_active: nk_style_item;
    pressed_active: nk_style_item;
    text_normal: nk_color;
    text_hover: nk_color;
    text_pressed: nk_color;
    text_normal_active: nk_color;
    text_hover_active: nk_color;
    text_pressed_active: nk_color;
    text_background: nk_color;
    text_alignment: nk_flags;
    rounding: Single;
    padding: nk_vec2;
    touch_padding: nk_vec2;
    image_padding: nk_vec2;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_slider = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    bar_normal: nk_color;
    bar_hover: nk_color;
    bar_active: nk_color;
    bar_filled: nk_color;
    cursor_normal: nk_style_item;
    cursor_hover: nk_style_item;
    cursor_active: nk_style_item;
    border: Single;
    rounding: Single;
    bar_height: Single;
    padding: nk_vec2;
    spacing: nk_vec2;
    cursor_size: nk_vec2;
    show_buttons: Integer;
    inc_button: nk_style_button;
    dec_button: nk_style_button;
    inc_symbol: nk_symbol_type;
    dec_symbol: nk_symbol_type;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_progress = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    cursor_normal: nk_style_item;
    cursor_hover: nk_style_item;
    cursor_active: nk_style_item;
    cursor_border_color: nk_color;
    rounding: Single;
    border: Single;
    cursor_border: Single;
    cursor_rounding: Single;
    padding: nk_vec2;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_scrollbar = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    cursor_normal: nk_style_item;
    cursor_hover: nk_style_item;
    cursor_active: nk_style_item;
    cursor_border_color: nk_color;
    border: Single;
    rounding: Single;
    border_cursor: Single;
    rounding_cursor: Single;
    padding: nk_vec2;
    show_buttons: Integer;
    inc_button: nk_style_button;
    dec_button: nk_style_button;
    inc_symbol: nk_symbol_type;
    dec_symbol: nk_symbol_type;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_edit = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    scrollbar: nk_style_scrollbar;
    cursor_normal: nk_color;
    cursor_hover: nk_color;
    cursor_text_normal: nk_color;
    cursor_text_hover: nk_color;
    text_normal: nk_color;
    text_hover: nk_color;
    text_active: nk_color;
    selected_normal: nk_color;
    selected_hover: nk_color;
    selected_text_normal: nk_color;
    selected_text_hover: nk_color;
    border: Single;
    rounding: Single;
    cursor_size: Single;
    scrollbar_size: nk_vec2;
    padding: nk_vec2;
    row_padding: Single;
  end;

  nk_style_property = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    label_normal: nk_color;
    label_hover: nk_color;
    label_active: nk_color;
    sym_left: nk_symbol_type;
    sym_right: nk_symbol_type;
    border: Single;
    rounding: Single;
    padding: nk_vec2;
    edit: nk_style_edit;
    inc_button: nk_style_button;
    dec_button: nk_style_button;
    userdata: nk_handle;
    draw_begin: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
    draw_end: procedure(p1: Pnk_command_buffer; p2: nk_handle); cdecl;
  end;

  nk_style_chart = record
    background: nk_style_item;
    border_color: nk_color;
    selected_color: nk_color;
    color: nk_color;
    border: Single;
    rounding: Single;
    padding: nk_vec2;
  end;

  nk_style_combo = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    border_color: nk_color;
    label_normal: nk_color;
    label_hover: nk_color;
    label_active: nk_color;
    symbol_normal: nk_color;
    symbol_hover: nk_color;
    symbol_active: nk_color;
    button: nk_style_button;
    sym_normal: nk_symbol_type;
    sym_hover: nk_symbol_type;
    sym_active: nk_symbol_type;
    border: Single;
    rounding: Single;
    content_padding: nk_vec2;
    button_padding: nk_vec2;
    spacing: nk_vec2;
  end;

  nk_style_tab = record
    background: nk_style_item;
    border_color: nk_color;
    text: nk_color;
    tab_maximize_button: nk_style_button;
    tab_minimize_button: nk_style_button;
    node_maximize_button: nk_style_button;
    node_minimize_button: nk_style_button;
    sym_minimize: nk_symbol_type;
    sym_maximize: nk_symbol_type;
    border: Single;
    rounding: Single;
    indent: Single;
    padding: nk_vec2;
    spacing: nk_vec2;
  end;

  nk_style_window_header = record
    normal: nk_style_item;
    hover: nk_style_item;
    active: nk_style_item;
    close_button: nk_style_button;
    minimize_button: nk_style_button;
    close_symbol: nk_symbol_type;
    minimize_symbol: nk_symbol_type;
    maximize_symbol: nk_symbol_type;
    label_normal: nk_color;
    label_hover: nk_color;
    label_active: nk_color;
    align: nk_style_header_align;
    padding: nk_vec2;
    label_padding: nk_vec2;
    spacing: nk_vec2;
  end;

  nk_style_window = record
    header: nk_style_window_header;
    fixed_background: nk_style_item;
    background: nk_color;
    border_color: nk_color;
    popup_border_color: nk_color;
    combo_border_color: nk_color;
    contextual_border_color: nk_color;
    menu_border_color: nk_color;
    group_border_color: nk_color;
    tooltip_border_color: nk_color;
    scaler: nk_style_item;
    border: Single;
    combo_border: Single;
    contextual_border: Single;
    menu_border: Single;
    group_border: Single;
    tooltip_border: Single;
    popup_border: Single;
    min_row_height_padding: Single;
    rounding: Single;
    spacing: nk_vec2;
    scrollbar_size: nk_vec2;
    min_size: nk_vec2;
    padding: nk_vec2;
    group_padding: nk_vec2;
    popup_padding: nk_vec2;
    combo_padding: nk_vec2;
    contextual_padding: nk_vec2;
    menu_padding: nk_vec2;
    tooltip_padding: nk_vec2;
  end;

  nk_style = record
    font: Pnk_user_font;
    cursors: array [0..6] of Pnk_cursor;
    cursor_active: Pnk_cursor;
    cursor_last: Pnk_cursor;
    cursor_visible: Integer;
    text: nk_style_text;
    button: nk_style_button;
    contextual_button: nk_style_button;
    menu_button: nk_style_button;
    option: nk_style_toggle;
    checkbox: nk_style_toggle;
    selectable: nk_style_selectable;
    slider: nk_style_slider;
    progress: nk_style_progress;
    &property: nk_style_property;
    edit: nk_style_edit;
    chart: nk_style_chart;
    scrollh: nk_style_scrollbar;
    scrollv: nk_style_scrollbar;
    tab: nk_style_tab;
    combo: nk_style_combo;
    window: nk_style_window;
  end;

  nk_chart_slot = record
    &type: nk_chart_type;
    color: nk_color;
    highlight: nk_color;
    min: Single;
    max: Single;
    range: Single;
    count: Integer;
    last: nk_vec2;
    index: Integer;
  end;

  nk_chart = record
    slot: Integer;
    x: Single;
    y: Single;
    w: Single;
    h: Single;
    slots: array [0..3] of nk_chart_slot;
  end;

  nk_row_layout = record
    &type: nk_panel_row_layout_type;
    index: Integer;
    height: Single;
    min_height: Single;
    columns: Integer;
    ratio: PSingle;
    item_width: Single;
    item_height: Single;
    item_offset: Single;
    filled: Single;
    item: nk_rect;
    tree_depth: Integer;
    templates: array [0..15] of Single;
  end;

  nk_popup_buffer = record
    &begin: nk_size;
    parent: nk_size;
    last: nk_size;
    &end: nk_size;
    active: Integer;
  end;

  nk_menu_state = record
    x: Single;
    y: Single;
    w: Single;
    h: Single;
    offset: nk_scroll;
  end;

  nk_panel = record
    &type: nk_panel_type;
    flags: nk_flags;
    bounds: nk_rect;
    offset_x: Pnk_uint;
    offset_y: Pnk_uint;
    at_x: Single;
    at_y: Single;
    max_x: Single;
    footer_height: Single;
    header_height: Single;
    border: Single;
    has_scrolling: Cardinal;
    clip: nk_rect;
    menu: nk_menu_state;
    row: nk_row_layout;
    chart: nk_chart;
    buffer: Pnk_command_buffer;
    parent: Pnk_panel;
  end;

  nk_popup_state = record
    win: Pnk_window;
    &type: nk_panel_type;
    buf: nk_popup_buffer;
    name: nk_hash;
    active: Integer;
    combo_count: Cardinal;
    con_count: Cardinal;
    con_old: Cardinal;
    active_con: Cardinal;
    header: nk_rect;
  end;

  nk_edit_state = record
    name: nk_hash;
    seq: Cardinal;
    old: Cardinal;
    active: Integer;
    prev: Integer;
    cursor: Integer;
    sel_start: Integer;
    sel_end: Integer;
    scrollbar: nk_scroll;
    mode: Byte;
    single_line: Byte;
  end;

  nk_property_state = record
    active: Integer;
    prev: Integer;
    buffer: array [0..63] of UTF8Char;
    length: Integer;
    cursor: Integer;
    select_start: Integer;
    select_end: Integer;
    name: nk_hash;
    seq: Cardinal;
    old: Cardinal;
    state: Integer;
  end;

  nk_window = record
    seq: Cardinal;
    name: nk_hash;
    name_string: array [0..63] of UTF8Char;
    flags: nk_flags;
    bounds: nk_rect;
    scrollbar: nk_scroll;
    buffer: nk_command_buffer;
    layout: Pnk_panel;
    scrollbar_hiding_timer: Single;
    &property: nk_property_state;
    popup: nk_popup_state;
    edit: nk_edit_state;
    scrolled: Cardinal;
    tables: Pnk_table;
    table_count: Cardinal;
    next: Pnk_window;
    prev: Pnk_window;
    parent: Pnk_window;
  end;

  nk_config_stack_style_item_element = record
    address: Pnk_style_item;
    old_value: nk_style_item;
  end;

  nk_config_stack_float_element = record
    address: PSingle;
    old_value: Single;
  end;

  nk_config_stack_vec2_element = record
    address: Pnk_vec2;
    old_value: nk_vec2;
  end;

  nk_config_stack_flags_element = record
    address: Pnk_flags;
    old_value: nk_flags;
  end;

  nk_config_stack_color_element = record
    address: Pnk_color;
    old_value: nk_color;
  end;

  nk_config_stack_user_font_element = record
    address: PPnk_user_font;
    old_value: Pnk_user_font;
  end;

  nk_config_stack_button_behavior_element = record
    address: Pnk_button_behavior;
    old_value: nk_button_behavior;
  end;

  nk_config_stack_style_item = record
    head: Integer;
    elements: array [0..15] of nk_config_stack_style_item_element;
  end;

  nk_config_stack_float = record
    head: Integer;
    elements: array [0..31] of nk_config_stack_float_element;
  end;

  nk_config_stack_vec2 = record
    head: Integer;
    elements: array [0..15] of nk_config_stack_vec2_element;
  end;

  nk_config_stack_flags = record
    head: Integer;
    elements: array [0..31] of nk_config_stack_flags_element;
  end;

  nk_config_stack_color = record
    head: Integer;
    elements: array [0..31] of nk_config_stack_color_element;
  end;

  nk_config_stack_user_font = record
    head: Integer;
    elements: array [0..7] of nk_config_stack_user_font_element;
  end;

  nk_config_stack_button_behavior = record
    head: Integer;
    elements: array [0..7] of nk_config_stack_button_behavior_element;
  end;

  nk_configuration_stacks = record
    style_items: nk_config_stack_style_item;
    floats: nk_config_stack_float;
    vectors: nk_config_stack_vec2;
    flags: nk_config_stack_flags;
    colors: nk_config_stack_color;
    fonts: nk_config_stack_user_font;
    button_behaviors: nk_config_stack_button_behavior;
  end;

  nk_table = record
    seq: Cardinal;
    size: Cardinal;
    keys: array [0..58] of nk_hash;
    values: array [0..58] of nk_uint;
    next: Pnk_table;
    prev: Pnk_table;
  end;

  nk_page_data = record
    case Integer of
      0: (tbl: nk_table);
      1: (pan: nk_panel);
      2: (win: nk_window);
  end;

  nk_page_element = record
    data: nk_page_data;
    next: Pnk_page_element;
    prev: Pnk_page_element;
  end;

  nk_page = record
    size: Cardinal;
    next: Pnk_page;
    win: array [0..0] of nk_page_element;
  end;

  nk_pool = record
    alloc: nk_allocator;
    &type: nk_allocation_type;
    page_count: Cardinal;
    pages: Pnk_page;
    freelist: Pnk_page_element;
    capacity: Cardinal;
    size: nk_size;
    cap: nk_size;
  end;

  nk_context = record
    input: nk_input;
    style: nk_style;
    memory: nk_buffer;
    clip: nk_clipboard;
    last_widget_state: nk_flags;
    button_behavior: nk_button_behavior;
    stacks: nk_configuration_stacks;
    delta_time_seconds: Single;
    text_edit: nk_text_edit;
    overlay: nk_command_buffer;
    build: Integer;
    use_pool: Integer;
    pool: nk_pool;
    &begin: Pnk_window;
    &end: Pnk_window;
    active: Pnk_window;
    current: Pnk_window;
    freelist: Pnk_page_element;
    count: Cardinal;
    seq: Cardinal;
  end;

  nk_plot_function_value_getter = function(user: Pointer; index: Integer): Single; cdecl;
  nk_combo_callback_item_getter = procedure(p1: Pointer; p2: Integer; p3: PPUTF8Char); cdecl;
  nk_combobox_callback_item_getter = procedure(p1: Pointer; p2: Integer; p3: PPUTF8Char); cdecl;


var
  nk_init_default: function(p1: Pnk_context; const p2: Pnk_user_font): Integer; cdecl;
  nk_init_fixed: function(p1: Pnk_context; memory: Pointer; size: nk_size; const p4: Pnk_user_font): Integer; cdecl;
  nk_init: function(p1: Pnk_context; p2: Pnk_allocator; const p3: Pnk_user_font): Integer; cdecl;
  nk_init_custom: function(p1: Pnk_context; cmds: Pnk_buffer; pool: Pnk_buffer; const p4: Pnk_user_font): Integer; cdecl;
  nk_clear: procedure(p1: Pnk_context); cdecl;
  nk_free: procedure(p1: Pnk_context); cdecl;
  nk_input_begin: procedure(p1: Pnk_context); cdecl;
  nk_input_motion: procedure(p1: Pnk_context; x: Integer; y: Integer); cdecl;
  nk_input_key: procedure(p1: Pnk_context; p2: nk_keys; down: Integer); cdecl;
  nk_input_button: procedure(p1: Pnk_context; p2: nk_buttons; x: Integer; y: Integer; down: Integer); cdecl;
  nk_input_scroll: procedure(p1: Pnk_context; val: nk_vec2); cdecl;
  nk_input_char: procedure(p1: Pnk_context; p2: UTF8Char); cdecl;
  nk_input_glyph: procedure(p1: Pnk_context; const p2: nk_glyph); cdecl;
  nk_input_unicode: procedure(p1: Pnk_context; p2: nk_rune); cdecl;
  nk_input_end: procedure(p1: Pnk_context); cdecl;
  nk__begin: function(p1: Pnk_context): Pnk_command; cdecl;
  nk__next: function(p1: Pnk_context; const p2: Pnk_command): Pnk_command; cdecl;
  nk_begin: function(ctx: Pnk_context; const title: PUTF8Char; bounds: nk_rect; flags: nk_flags): Integer; cdecl;
  nk_begin_titled: function(ctx: Pnk_context; const name: PUTF8Char; const title: PUTF8Char; bounds: nk_rect; flags: nk_flags): Integer; cdecl;
  nk_end: procedure(ctx: Pnk_context); cdecl;
  nk_window_find: function(ctx: Pnk_context; const name: PUTF8Char): Pnk_window; cdecl;
  nk_window_get_bounds: function(const ctx: Pnk_context): nk_rect; cdecl;
  nk_window_get_position: function(const ctx: Pnk_context): nk_vec2; cdecl;
  nk_window_get_size: function(const p1: Pnk_context): nk_vec2; cdecl;
  nk_window_get_width: function(const p1: Pnk_context): Single; cdecl;
  nk_window_get_height: function(const p1: Pnk_context): Single; cdecl;
  nk_window_get_panel: function(p1: Pnk_context): Pnk_panel; cdecl;
  nk_window_get_content_region: function(p1: Pnk_context): nk_rect; cdecl;
  nk_window_get_content_region_min: function(p1: Pnk_context): nk_vec2; cdecl;
  nk_window_get_content_region_max: function(p1: Pnk_context): nk_vec2; cdecl;
  nk_window_get_content_region_size: function(p1: Pnk_context): nk_vec2; cdecl;
  nk_window_get_canvas: function(p1: Pnk_context): Pnk_command_buffer; cdecl;
  nk_window_get_scroll: procedure(p1: Pnk_context; offset_x: Pnk_uint; offset_y: Pnk_uint); cdecl;
  nk_window_has_focus: function(const p1: Pnk_context): Integer; cdecl;
  nk_window_is_hovered: function(p1: Pnk_context): Integer; cdecl;
  nk_window_is_collapsed: function(ctx: Pnk_context; const name: PUTF8Char): Integer; cdecl;
  nk_window_is_closed: function(p1: Pnk_context; const p2: PUTF8Char): Integer; cdecl;
  nk_window_is_hidden: function(p1: Pnk_context; const p2: PUTF8Char): Integer; cdecl;
  nk_window_is_active: function(p1: Pnk_context; const p2: PUTF8Char): Integer; cdecl;
  nk_window_is_any_hovered: function(p1: Pnk_context): Integer; cdecl;
  nk_item_is_any_active: function(p1: Pnk_context): Integer; cdecl;
  nk_window_set_bounds: procedure(p1: Pnk_context; const name: PUTF8Char; bounds: nk_rect); cdecl;
  nk_window_set_position: procedure(p1: Pnk_context; const name: PUTF8Char; pos: nk_vec2); cdecl;
  nk_window_set_size: procedure(p1: Pnk_context; const name: PUTF8Char; p3: nk_vec2); cdecl;
  nk_window_set_focus: procedure(p1: Pnk_context; const name: PUTF8Char); cdecl;
  nk_window_set_scroll: procedure(p1: Pnk_context; offset_x: nk_uint; offset_y: nk_uint); cdecl;
  nk_window_close: procedure(ctx: Pnk_context; const name: PUTF8Char); cdecl;
  nk_window_collapse: procedure(p1: Pnk_context; const name: PUTF8Char; state: nk_collapse_states); cdecl;
  nk_window_collapse_if: procedure(p1: Pnk_context; const name: PUTF8Char; p3: nk_collapse_states; cond: Integer); cdecl;
  nk_window_show: procedure(p1: Pnk_context; const name: PUTF8Char; p3: nk_show_states); cdecl;
  nk_window_show_if: procedure(p1: Pnk_context; const name: PUTF8Char; p3: nk_show_states; cond: Integer); cdecl;
  nk_layout_set_min_row_height: procedure(p1: Pnk_context; height: Single); cdecl;
  nk_layout_reset_min_row_height: procedure(p1: Pnk_context); cdecl;
  nk_layout_widget_bounds: function(p1: Pnk_context): nk_rect; cdecl;
  nk_layout_ratio_from_pixel: function(p1: Pnk_context; pixel_width: Single): Single; cdecl;
  nk_layout_row_dynamic: procedure(ctx: Pnk_context; height: Single; cols: Integer); cdecl;
  nk_layout_row_static: procedure(ctx: Pnk_context; height: Single; item_width: Integer; cols: Integer); cdecl;
  nk_layout_row_begin: procedure(ctx: Pnk_context; fmt: nk_layout_format; row_height: Single; cols: Integer); cdecl;
  nk_layout_row_push: procedure(p1: Pnk_context; value: Single); cdecl;
  nk_layout_row_end: procedure(p1: Pnk_context); cdecl;
  nk_layout_row: procedure(p1: Pnk_context; p2: nk_layout_format; height: Single; cols: Integer; const ratio: PSingle); cdecl;
  nk_layout_row_template_begin: procedure(p1: Pnk_context; row_height: Single); cdecl;
  nk_layout_row_template_push_dynamic: procedure(p1: Pnk_context); cdecl;
  nk_layout_row_template_push_variable: procedure(p1: Pnk_context; min_width: Single); cdecl;
  nk_layout_row_template_push_static: procedure(p1: Pnk_context; width: Single); cdecl;
  nk_layout_row_template_end: procedure(p1: Pnk_context); cdecl;
  nk_layout_space_begin: procedure(p1: Pnk_context; p2: nk_layout_format; height: Single; widget_count: Integer); cdecl;
  nk_layout_space_push: procedure(p1: Pnk_context; bounds: nk_rect); cdecl;
  nk_layout_space_end: procedure(p1: Pnk_context); cdecl;
  nk_layout_space_bounds: function(p1: Pnk_context): nk_rect; cdecl;
  nk_layout_space_to_screen: function(p1: Pnk_context; p2: nk_vec2): nk_vec2; cdecl;
  nk_layout_space_to_local: function(p1: Pnk_context; p2: nk_vec2): nk_vec2; cdecl;
  nk_layout_space_rect_to_screen: function(p1: Pnk_context; p2: nk_rect): nk_rect; cdecl;
  nk_layout_space_rect_to_local: function(p1: Pnk_context; p2: nk_rect): nk_rect; cdecl;
  nk_group_begin: function(p1: Pnk_context; const title: PUTF8Char; p3: nk_flags): Integer; cdecl;
  nk_group_begin_titled: function(p1: Pnk_context; const name: PUTF8Char; const title: PUTF8Char; p4: nk_flags): Integer; cdecl;
  nk_group_end: procedure(p1: Pnk_context); cdecl;
  nk_group_scrolled_offset_begin: function(p1: Pnk_context; x_offset: Pnk_uint; y_offset: Pnk_uint; const title: PUTF8Char; flags: nk_flags): Integer; cdecl;
  nk_group_scrolled_begin: function(p1: Pnk_context; off: Pnk_scroll; const title: PUTF8Char; p4: nk_flags): Integer; cdecl;
  nk_group_scrolled_end: procedure(p1: Pnk_context); cdecl;
  nk_group_get_scroll: procedure(p1: Pnk_context; const id: PUTF8Char; x_offset: Pnk_uint; y_offset: Pnk_uint); cdecl;
  nk_group_set_scroll: procedure(p1: Pnk_context; const id: PUTF8Char; x_offset: nk_uint; y_offset: nk_uint); cdecl;
  nk_tree_push_hashed: function(p1: Pnk_context; p2: nk_tree_type; const title: PUTF8Char; initial_state: nk_collapse_states; const hash: PUTF8Char; len: Integer; seed: Integer): Integer; cdecl;
  nk_tree_image_push_hashed: function(p1: Pnk_context; p2: nk_tree_type; p3: nk_image; const title: PUTF8Char; initial_state: nk_collapse_states; const hash: PUTF8Char; len: Integer; seed: Integer): Integer; cdecl;
  nk_tree_pop: procedure(p1: Pnk_context); cdecl;
  nk_tree_state_push: function(p1: Pnk_context; p2: nk_tree_type; const title: PUTF8Char; state: Pnk_collapse_states): Integer; cdecl;
  nk_tree_state_image_push: function(p1: Pnk_context; p2: nk_tree_type; p3: nk_image; const title: PUTF8Char; state: Pnk_collapse_states): Integer; cdecl;
  nk_tree_state_pop: procedure(p1: Pnk_context); cdecl;
  nk_tree_element_push_hashed: function(p1: Pnk_context; p2: nk_tree_type; const title: PUTF8Char; initial_state: nk_collapse_states; selected: PInteger; const hash: PUTF8Char; len: Integer; seed: Integer): Integer; cdecl;
  nk_tree_element_image_push_hashed: function(p1: Pnk_context; p2: nk_tree_type; p3: nk_image; const title: PUTF8Char; initial_state: nk_collapse_states; selected: PInteger; const hash: PUTF8Char; len: Integer; seed: Integer): Integer; cdecl;
  nk_tree_element_pop: procedure(p1: Pnk_context); cdecl;
  nk_list_view_begin: function(p1: Pnk_context; &out: Pnk_list_view; const id: PUTF8Char; p4: nk_flags; row_height: Integer; row_count: Integer): Integer; cdecl;
  nk_list_view_end: procedure(p1: Pnk_list_view); cdecl;
  nk_widget: function(p1: Pnk_rect; const p2: Pnk_context): nk_widget_layout_states; cdecl;
  nk_widget_fitting: function(p1: Pnk_rect; p2: Pnk_context; p3: nk_vec2): nk_widget_layout_states; cdecl;
  nk_widget_bounds: function(p1: Pnk_context): nk_rect; cdecl;
  nk_widget_position: function(p1: Pnk_context): nk_vec2; cdecl;
  nk_widget_size: function(p1: Pnk_context): nk_vec2; cdecl;
  nk_widget_width: function(p1: Pnk_context): Single; cdecl;
  nk_widget_height: function(p1: Pnk_context): Single; cdecl;
  nk_widget_is_hovered: function(p1: Pnk_context): Integer; cdecl;
  nk_widget_is_mouse_clicked: function(p1: Pnk_context; p2: nk_buttons): Integer; cdecl;
  nk_widget_has_mouse_click_down: function(p1: Pnk_context; p2: nk_buttons; down: Integer): Integer; cdecl;
  nk_spacing: procedure(p1: Pnk_context; cols: Integer); cdecl;
  nk_text: procedure(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; p4: nk_flags); cdecl;
  nk_text_colored: procedure(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; p4: nk_flags; p5: nk_color); cdecl;
  nk_text_wrap: procedure(p1: Pnk_context; const p2: PUTF8Char; p3: Integer); cdecl;
  nk_text_wrap_colored: procedure(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; p4: nk_color); cdecl;
  nk_label: procedure(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags); cdecl;
  nk_label_colored: procedure(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; p4: nk_color); cdecl;
  nk_label_wrap: procedure(p1: Pnk_context; const p2: PUTF8Char); cdecl;
  nk_label_colored_wrap: procedure(p1: Pnk_context; const p2: PUTF8Char; p3: nk_color); cdecl;
  nk_image_: procedure(p1: Pnk_context; p2: nk_image); cdecl;
  nk_image_color: procedure(p1: Pnk_context; p2: nk_image; p3: nk_color); cdecl;
  nk_button_text: function(p1: Pnk_context; const title: PUTF8Char; len: Integer): Integer; cdecl;
  nk_button_label: function(p1: Pnk_context; const title: PUTF8Char): Integer; cdecl;
  nk_button_color: function(p1: Pnk_context; p2: nk_color): Integer; cdecl;
  nk_button_symbol: function(p1: Pnk_context; p2: nk_symbol_type): Integer; cdecl;
  nk_button_image: function(p1: Pnk_context; img: nk_image): Integer; cdecl;
  nk_button_symbol_label: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; text_alignment: nk_flags): Integer; cdecl;
  nk_button_symbol_text: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): Integer; cdecl;
  nk_button_image_label: function(p1: Pnk_context; img: nk_image; const p3: PUTF8Char; text_alignment: nk_flags): Integer; cdecl;
  nk_button_image_text: function(p1: Pnk_context; img: nk_image; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): Integer; cdecl;
  nk_button_text_styled: function(p1: Pnk_context; const p2: Pnk_style_button; const title: PUTF8Char; len: Integer): Integer; cdecl;
  nk_button_label_styled: function(p1: Pnk_context; const p2: Pnk_style_button; const title: PUTF8Char): Integer; cdecl;
  nk_button_symbol_styled: function(p1: Pnk_context; const p2: Pnk_style_button; p3: nk_symbol_type): Integer; cdecl;
  nk_button_image_styled: function(p1: Pnk_context; const p2: Pnk_style_button; img: nk_image): Integer; cdecl;
  nk_button_symbol_text_styled: function(p1: Pnk_context; const p2: Pnk_style_button; p3: nk_symbol_type; const p4: PUTF8Char; p5: Integer; alignment: nk_flags): Integer; cdecl;
  nk_button_symbol_label_styled: function(ctx: Pnk_context; const style: Pnk_style_button; symbol: nk_symbol_type; const title: PUTF8Char; align: nk_flags): Integer; cdecl;
  nk_button_image_label_styled: function(p1: Pnk_context; const p2: Pnk_style_button; img: nk_image; const p4: PUTF8Char; text_alignment: nk_flags): Integer; cdecl;
  nk_button_image_text_styled: function(p1: Pnk_context; const p2: Pnk_style_button; img: nk_image; const p4: PUTF8Char; p5: Integer; alignment: nk_flags): Integer; cdecl;
  nk_button_set_behavior: procedure(p1: Pnk_context; p2: nk_button_behavior); cdecl;
  nk_button_push_behavior: function(p1: Pnk_context; p2: nk_button_behavior): Integer; cdecl;
  nk_button_pop_behavior: function(p1: Pnk_context): Integer; cdecl;
  nk_check_label: function(p1: Pnk_context; const p2: PUTF8Char; active: Integer): Integer; cdecl;
  nk_check_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; active: Integer): Integer; cdecl;
  nk_check_flags_label: function(p1: Pnk_context; const p2: PUTF8Char; flags: Cardinal; value: Cardinal): Cardinal; cdecl;
  nk_check_flags_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; flags: Cardinal; value: Cardinal): Cardinal; cdecl;
  nk_checkbox_label: function(p1: Pnk_context; const p2: PUTF8Char; active: PInteger): Integer; cdecl;
  nk_checkbox_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; active: PInteger): Integer; cdecl;
  nk_checkbox_flags_label: function(p1: Pnk_context; const p2: PUTF8Char; flags: PCardinal; value: Cardinal): Integer; cdecl;
  nk_checkbox_flags_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; flags: PCardinal; value: Cardinal): Integer; cdecl;
  nk_radio_label: function(p1: Pnk_context; const p2: PUTF8Char; active: PInteger): Integer; cdecl;
  nk_radio_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; active: PInteger): Integer; cdecl;
  nk_option_label: function(p1: Pnk_context; const p2: PUTF8Char; active: Integer): Integer; cdecl;
  nk_option_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; active: Integer): Integer; cdecl;
  nk_selectable_label: function(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; value: PInteger): Integer; cdecl;
  nk_selectable_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags; value: PInteger): Integer; cdecl;
  nk_selectable_image_label: function(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; align: nk_flags; value: PInteger): Integer; cdecl;
  nk_selectable_image_text: function(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; p4: Integer; align: nk_flags; value: PInteger): Integer; cdecl;
  nk_selectable_symbol_label: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; align: nk_flags; value: PInteger): Integer; cdecl;
  nk_selectable_symbol_text: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; align: nk_flags; value: PInteger): Integer; cdecl;
  nk_select_label: function(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; value: Integer): Integer; cdecl;
  nk_select_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags; value: Integer): Integer; cdecl;
  nk_select_image_label: function(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; align: nk_flags; value: Integer): Integer; cdecl;
  nk_select_image_text: function(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; p4: Integer; align: nk_flags; value: Integer): Integer; cdecl;
  nk_select_symbol_label: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; align: nk_flags; value: Integer): Integer; cdecl;
  nk_select_symbol_text: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; align: nk_flags; value: Integer): Integer; cdecl;
  nk_slide_float: function(p1: Pnk_context; min: Single; val: Single; max: Single; step: Single): Single; cdecl;
  nk_slide_int: function(p1: Pnk_context; min: Integer; val: Integer; max: Integer; step: Integer): Integer; cdecl;
  nk_slider_float: function(p1: Pnk_context; min: Single; val: PSingle; max: Single; step: Single): Integer; cdecl;
  nk_slider_int: function(p1: Pnk_context; min: Integer; val: PInteger; max: Integer; step: Integer): Integer; cdecl;
  nk_progress: function(p1: Pnk_context; cur: Pnk_size; max: nk_size; modifyable: Integer): Integer; cdecl;
  nk_prog: function(p1: Pnk_context; cur: nk_size; max: nk_size; modifyable: Integer): nk_size; cdecl;
  nk_color_picker: function(p1: Pnk_context; p2: nk_colorf; p3: nk_color_format): nk_colorf; cdecl;
  nk_color_pick: function(p1: Pnk_context; p2: Pnk_colorf; p3: nk_color_format): Integer; cdecl;
  nk_property_int: procedure(p1: Pnk_context; const name: PUTF8Char; min: Integer; val: PInteger; max: Integer; step: Integer; inc_per_pixel: Single); cdecl;
  nk_property_float: procedure(p1: Pnk_context; const name: PUTF8Char; min: Single; val: PSingle; max: Single; step: Single; inc_per_pixel: Single); cdecl;
  nk_property_double: procedure(p1: Pnk_context; const name: PUTF8Char; min: Double; val: PDouble; max: Double; step: Double; inc_per_pixel: Single); cdecl;
  nk_propertyi: function(p1: Pnk_context; const name: PUTF8Char; min: Integer; val: Integer; max: Integer; step: Integer; inc_per_pixel: Single): Integer; cdecl;
  nk_propertyf: function(p1: Pnk_context; const name: PUTF8Char; min: Single; val: Single; max: Single; step: Single; inc_per_pixel: Single): Single; cdecl;
  nk_propertyd: function(p1: Pnk_context; const name: PUTF8Char; min: Double; val: Double; max: Double; step: Double; inc_per_pixel: Single): Double; cdecl;
  nk_edit_string: function(p1: Pnk_context; p2: nk_flags; buffer: PUTF8Char; len: PInteger; max: Integer; p6: nk_plugin_filter): nk_flags; cdecl;
  nk_edit_string_zero_terminated: function(p1: Pnk_context; p2: nk_flags; buffer: PUTF8Char; max: Integer; p5: nk_plugin_filter): nk_flags; cdecl;
  nk_edit_buffer: function(p1: Pnk_context; p2: nk_flags; p3: Pnk_text_edit; p4: nk_plugin_filter): nk_flags; cdecl;
  nk_edit_focus: procedure(p1: Pnk_context; flags: nk_flags); cdecl;
  nk_edit_unfocus: procedure(p1: Pnk_context); cdecl;
  nk_chart_begin: function(p1: Pnk_context; p2: nk_chart_type; num: Integer; min: Single; max: Single): Integer; cdecl;
  nk_chart_begin_colored: function(p1: Pnk_context; p2: nk_chart_type; p3: nk_color; active: nk_color; num: Integer; min: Single; max: Single): Integer; cdecl;
  nk_chart_add_slot: procedure(ctx: Pnk_context; const p2: nk_chart_type; count: Integer; min_value: Single; max_value: Single); cdecl;
  nk_chart_add_slot_colored: procedure(ctx: Pnk_context; const p2: nk_chart_type; p3: nk_color; active: nk_color; count: Integer; min_value: Single; max_value: Single); cdecl;
  nk_chart_push: function(p1: Pnk_context; p2: Single): nk_flags; cdecl;
  nk_chart_push_slot: function(p1: Pnk_context; p2: Single; p3: Integer): nk_flags; cdecl;
  nk_chart_end: procedure(p1: Pnk_context); cdecl;
  nk_plot: procedure(p1: Pnk_context; p2: nk_chart_type; const values: PSingle; count: Integer; offset: Integer); cdecl;
  nk_plot_function: procedure(p1: Pnk_context; p2: nk_chart_type; userdata: Pointer; value_getter: nk_plot_function_value_getter; count: Integer; offset: Integer); cdecl;
  nk_popup_begin: function(p1: Pnk_context; p2: nk_popup_type; const p3: PUTF8Char; p4: nk_flags; bounds: nk_rect): Integer; cdecl;
  nk_popup_close: procedure(p1: Pnk_context); cdecl;
  nk_popup_end: procedure(p1: Pnk_context); cdecl;
  nk_popup_get_scroll: procedure(p1: Pnk_context; offset_x: Pnk_uint; offset_y: Pnk_uint); cdecl;
  nk_popup_set_scroll: procedure(p1: Pnk_context; offset_x: nk_uint; offset_y: nk_uint); cdecl;
  nk_combo: function(p1: Pnk_context; items: PPUTF8Char; count: Integer; selected: Integer; item_height: Integer; size: nk_vec2): Integer; cdecl;
  nk_combo_separator: function(p1: Pnk_context; const items_separated_by_separator: PUTF8Char; separator: Integer; selected: Integer; count: Integer; item_height: Integer; size: nk_vec2): Integer; cdecl;
  nk_combo_string: function(p1: Pnk_context; const items_separated_by_zeros: PUTF8Char; selected: Integer; count: Integer; item_height: Integer; size: nk_vec2): Integer; cdecl;
  nk_combo_callback: function(p1: Pnk_context; item_getter: nk_combo_callback_item_getter; userdata: Pointer; selected: Integer; count: Integer; item_height: Integer; size: nk_vec2): Integer; cdecl;
  nk_combobox: procedure(p1: Pnk_context; items: PPUTF8Char; count: Integer; selected: PInteger; item_height: Integer; size: nk_vec2); cdecl;
  nk_combobox_string: procedure(p1: Pnk_context; const items_separated_by_zeros: PUTF8Char; selected: PInteger; count: Integer; item_height: Integer; size: nk_vec2); cdecl;
  nk_combobox_separator: procedure(p1: Pnk_context; const items_separated_by_separator: PUTF8Char; separator: Integer; selected: PInteger; count: Integer; item_height: Integer; size: nk_vec2); cdecl;
  nk_combobox_callback: procedure(p1: Pnk_context; item_getter: nk_combobox_callback_item_getter; p3: Pointer; selected: PInteger; count: Integer; item_height: Integer; size: nk_vec2); cdecl;
  nk_combo_begin_text: function(p1: Pnk_context; const selected: PUTF8Char; p3: Integer; size: nk_vec2): Integer; cdecl;
  nk_combo_begin_label: function(p1: Pnk_context; const selected: PUTF8Char; size: nk_vec2): Integer; cdecl;
  nk_combo_begin_color: function(p1: Pnk_context; color: nk_color; size: nk_vec2): Integer; cdecl;
  nk_combo_begin_symbol: function(p1: Pnk_context; p2: nk_symbol_type; size: nk_vec2): Integer; cdecl;
  nk_combo_begin_symbol_label: function(p1: Pnk_context; const selected: PUTF8Char; p3: nk_symbol_type; size: nk_vec2): Integer; cdecl;
  nk_combo_begin_symbol_text: function(p1: Pnk_context; const selected: PUTF8Char; p3: Integer; p4: nk_symbol_type; size: nk_vec2): Integer; cdecl;
  nk_combo_begin_image: function(p1: Pnk_context; img: nk_image; size: nk_vec2): Integer; cdecl;
  nk_combo_begin_image_label: function(p1: Pnk_context; const selected: PUTF8Char; p3: nk_image; size: nk_vec2): Integer; cdecl;
  nk_combo_begin_image_text: function(p1: Pnk_context; const selected: PUTF8Char; p3: Integer; p4: nk_image; size: nk_vec2): Integer; cdecl;
  nk_combo_item_label: function(p1: Pnk_context; const p2: PUTF8Char; alignment: nk_flags): Integer; cdecl;
  nk_combo_item_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; alignment: nk_flags): Integer; cdecl;
  nk_combo_item_image_label: function(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; alignment: nk_flags): Integer; cdecl;
  nk_combo_item_image_text: function(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): Integer; cdecl;
  nk_combo_item_symbol_label: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; alignment: nk_flags): Integer; cdecl;
  nk_combo_item_symbol_text: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): Integer; cdecl;
  nk_combo_close: procedure(p1: Pnk_context); cdecl;
  nk_combo_end: procedure(p1: Pnk_context); cdecl;
  nk_contextual_begin: function(p1: Pnk_context; p2: nk_flags; p3: nk_vec2; trigger_bounds: nk_rect): Integer; cdecl;
  nk_contextual_item_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags): Integer; cdecl;
  nk_contextual_item_label: function(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags): Integer; cdecl;
  nk_contextual_item_image_label: function(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; alignment: nk_flags): Integer; cdecl;
  nk_contextual_item_image_text: function(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; len: Integer; alignment: nk_flags): Integer; cdecl;
  nk_contextual_item_symbol_label: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; alignment: nk_flags): Integer; cdecl;
  nk_contextual_item_symbol_text: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): Integer; cdecl;
  nk_contextual_close: procedure(p1: Pnk_context); cdecl;
  nk_contextual_end: procedure(p1: Pnk_context); cdecl;
  nk_tooltip: procedure(p1: Pnk_context; const p2: PUTF8Char); cdecl;
  nk_tooltip_begin: function(p1: Pnk_context; width: Single): Integer; cdecl;
  nk_tooltip_end: procedure(p1: Pnk_context); cdecl;
  nk_menubar_begin: procedure(p1: Pnk_context); cdecl;
  nk_menubar_end: procedure(p1: Pnk_context); cdecl;
  nk_menu_begin_text: function(p1: Pnk_context; const title: PUTF8Char; title_len: Integer; align: nk_flags; size: nk_vec2): Integer; cdecl;
  nk_menu_begin_label: function(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; size: nk_vec2): Integer; cdecl;
  nk_menu_begin_image: function(p1: Pnk_context; const p2: PUTF8Char; p3: nk_image; size: nk_vec2): Integer; cdecl;
  nk_menu_begin_image_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags; p5: nk_image; size: nk_vec2): Integer; cdecl;
  nk_menu_begin_image_label: function(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; p4: nk_image; size: nk_vec2): Integer; cdecl;
  nk_menu_begin_symbol: function(p1: Pnk_context; const p2: PUTF8Char; p3: nk_symbol_type; size: nk_vec2): Integer; cdecl;
  nk_menu_begin_symbol_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags; p5: nk_symbol_type; size: nk_vec2): Integer; cdecl;
  nk_menu_begin_symbol_label: function(p1: Pnk_context; const p2: PUTF8Char; align: nk_flags; p4: nk_symbol_type; size: nk_vec2): Integer; cdecl;
  nk_menu_item_text: function(p1: Pnk_context; const p2: PUTF8Char; p3: Integer; align: nk_flags): Integer; cdecl;
  nk_menu_item_label: function(p1: Pnk_context; const p2: PUTF8Char; alignment: nk_flags): Integer; cdecl;
  nk_menu_item_image_label: function(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; alignment: nk_flags): Integer; cdecl;
  nk_menu_item_image_text: function(p1: Pnk_context; p2: nk_image; const p3: PUTF8Char; len: Integer; alignment: nk_flags): Integer; cdecl;
  nk_menu_item_symbol_text: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; p4: Integer; alignment: nk_flags): Integer; cdecl;
  nk_menu_item_symbol_label: function(p1: Pnk_context; p2: nk_symbol_type; const p3: PUTF8Char; alignment: nk_flags): Integer; cdecl;
  nk_menu_close: procedure(p1: Pnk_context); cdecl;
  nk_menu_end: procedure(p1: Pnk_context); cdecl;
  nk_style_default: procedure(p1: Pnk_context); cdecl;
  nk_style_from_table: procedure(p1: Pnk_context; const p2: Pnk_color); cdecl;
  nk_style_load_cursor: procedure(p1: Pnk_context; p2: nk_style_cursor; const p3: Pnk_cursor); cdecl;
  nk_style_load_all_cursors: procedure(p1: Pnk_context; p2: Pnk_cursor); cdecl;
  nk_style_get_color_by_name: function(p1: nk_style_colors): PUTF8Char; cdecl;
  nk_style_set_font: procedure(p1: Pnk_context; const p2: Pnk_user_font); cdecl;
  nk_style_set_cursor: function(p1: Pnk_context; p2: nk_style_cursor): Integer; cdecl;
  nk_style_show_cursor: procedure(p1: Pnk_context); cdecl;
  nk_style_hide_cursor: procedure(p1: Pnk_context); cdecl;
  nk_style_push_font: function(p1: Pnk_context; const p2: Pnk_user_font): Integer; cdecl;
  nk_style_push_float: function(p1: Pnk_context; p2: PSingle; p3: Single): Integer; cdecl;
  nk_style_push_vec2: function(p1: Pnk_context; p2: Pnk_vec2; p3: nk_vec2): Integer; cdecl;
  nk_style_push_style_item: function(p1: Pnk_context; p2: Pnk_style_item; p3: nk_style_item): Integer; cdecl;
  nk_style_push_flags: function(p1: Pnk_context; p2: Pnk_flags; p3: nk_flags): Integer; cdecl;
  nk_style_push_color: function(p1: Pnk_context; p2: Pnk_color; p3: nk_color): Integer; cdecl;
  nk_style_pop_font: function(p1: Pnk_context): Integer; cdecl;
  nk_style_pop_float: function(p1: Pnk_context): Integer; cdecl;
  nk_style_pop_vec2: function(p1: Pnk_context): Integer; cdecl;
  nk_style_pop_style_item: function(p1: Pnk_context): Integer; cdecl;
  nk_style_pop_flags: function(p1: Pnk_context): Integer; cdecl;
  nk_style_pop_color: function(p1: Pnk_context): Integer; cdecl;
  nk_rgb_: function(r: Integer; g: Integer; b: Integer): nk_color; cdecl;
  nk_rgb_iv: function(const rgb: PInteger): nk_color; cdecl;
  nk_rgb_bv: function(const rgb: Pnk_byte): nk_color; cdecl;
  nk_rgb_f: function(r: Single; g: Single; b: Single): nk_color; cdecl;
  nk_rgb_fv: function(const rgb: PSingle): nk_color; cdecl;
  nk_rgb_cf: function(c: nk_colorf): nk_color; cdecl;
  nk_rgb_hex: function(const rgb: PUTF8Char): nk_color; cdecl;
  nk_rgba_: function(r: Integer; g: Integer; b: Integer; a: Integer): nk_color; cdecl;
  nk_rgba_u32: function(p1: nk_uint): nk_color; cdecl;
  nk_rgba_iv: function(const rgba: PInteger): nk_color; cdecl;
  nk_rgba_bv: function(const rgba: Pnk_byte): nk_color; cdecl;
  nk_rgba_f: function(r: Single; g: Single; b: Single; a: Single): nk_color; cdecl;
  nk_rgba_fv: function(const rgba: PSingle): nk_color; cdecl;
  nk_rgba_cf: function(c: nk_colorf): nk_color; cdecl;
  nk_rgba_hex: function(const rgb: PUTF8Char): nk_color; cdecl;
  nk_hsva_colorf: function(h: Single; s: Single; v: Single; a: Single): nk_colorf; cdecl;
  nk_hsva_colorfv: function(c: PSingle): nk_colorf; cdecl;
  nk_colorf_hsva_f: procedure(out_h: PSingle; out_s: PSingle; out_v: PSingle; out_a: PSingle; &in: nk_colorf); cdecl;
  nk_colorf_hsva_fv: procedure(hsva: PSingle; &in: nk_colorf); cdecl;
  nk_hsv: function(h: Integer; s: Integer; v: Integer): nk_color; cdecl;
  nk_hsv_iv: function(const hsv: PInteger): nk_color; cdecl;
  nk_hsv_bv: function(const hsv: Pnk_byte): nk_color; cdecl;
  nk_hsv_f: function(h: Single; s: Single; v: Single): nk_color; cdecl;
  nk_hsv_fv: function(const hsv: PSingle): nk_color; cdecl;
  nk_hsva: function(h: Integer; s: Integer; v: Integer; a: Integer): nk_color; cdecl;
  nk_hsva_iv: function(const hsva: PInteger): nk_color; cdecl;
  nk_hsva_bv: function(const hsva: Pnk_byte): nk_color; cdecl;
  nk_hsva_f: function(h: Single; s: Single; v: Single; a: Single): nk_color; cdecl;
  nk_hsva_fv: function(const hsva: PSingle): nk_color; cdecl;
  nk_color_f: procedure(r: PSingle; g: PSingle; b: PSingle; a: PSingle; p5: nk_color); cdecl;
  nk_color_fv: procedure(rgba_out: PSingle; p2: nk_color); cdecl;
  nk_color_cf: function(p1: nk_color): nk_colorf; cdecl;
  nk_color_d: procedure(r: PDouble; g: PDouble; b: PDouble; a: PDouble; p5: nk_color); cdecl;
  nk_color_dv: procedure(rgba_out: PDouble; p2: nk_color); cdecl;
  nk_color_u32: function(p1: nk_color): nk_uint; cdecl;
  nk_color_hex_rgba: procedure(output: PUTF8Char; p2: nk_color); cdecl;
  nk_color_hex_rgb: procedure(output: PUTF8Char; p2: nk_color); cdecl;
  nk_color_hsv_i: procedure(out_h: PInteger; out_s: PInteger; out_v: PInteger; p4: nk_color); cdecl;
  nk_color_hsv_b: procedure(out_h: Pnk_byte; out_s: Pnk_byte; out_v: Pnk_byte; p4: nk_color); cdecl;
  nk_color_hsv_iv: procedure(hsv_out: PInteger; p2: nk_color); cdecl;
  nk_color_hsv_bv: procedure(hsv_out: Pnk_byte; p2: nk_color); cdecl;
  nk_color_hsv_f: procedure(out_h: PSingle; out_s: PSingle; out_v: PSingle; p4: nk_color); cdecl;
  nk_color_hsv_fv: procedure(hsv_out: PSingle; p2: nk_color); cdecl;
  nk_color_hsva_i: procedure(h: PInteger; s: PInteger; v: PInteger; a: PInteger; p5: nk_color); cdecl;
  nk_color_hsva_b: procedure(h: Pnk_byte; s: Pnk_byte; v: Pnk_byte; a: Pnk_byte; p5: nk_color); cdecl;
  nk_color_hsva_iv: procedure(hsva_out: PInteger; p2: nk_color); cdecl;
  nk_color_hsva_bv: procedure(hsva_out: Pnk_byte; p2: nk_color); cdecl;
  nk_color_hsva_f: procedure(out_h: PSingle; out_s: PSingle; out_v: PSingle; out_a: PSingle; p5: nk_color); cdecl;
  nk_color_hsva_fv: procedure(hsva_out: PSingle; p2: nk_color); cdecl;
  nk_handle_ptr: function(p1: Pointer): nk_handle; cdecl;
  nk_handle_id: function(p1: Integer): nk_handle; cdecl;
  nk_image_handle: function(p1: nk_handle): nk_image; cdecl;
  nk_image_ptr: function(p1: Pointer): nk_image; cdecl;
  nk_image_id: function(p1: Integer): nk_image; cdecl;
  nk_image_is_subimage: function(const img: Pnk_image): Integer; cdecl;
  nk_subimage_ptr: function(p1: Pointer; w: Word; h: Word; sub_region: nk_rect): nk_image; cdecl;
  nk_subimage_id: function(p1: Integer; w: Word; h: Word; sub_region: nk_rect): nk_image; cdecl;
  nk_subimage_handle: function(p1: nk_handle; w: Word; h: Word; sub_region: nk_rect): nk_image; cdecl;
  nk_murmur_hash: function(const key: Pointer; len: Integer; seed: nk_hash): nk_hash; cdecl;
  nk_triangle_from_direction: procedure(result: Pnk_vec2; r: nk_rect; pad_x: Single; pad_y: Single; p5: nk_heading); cdecl;
  nk_vec2_: function(x: Single; y: Single): nk_vec2; cdecl;
  nk_vec2i_: function(x: Integer; y: Integer): nk_vec2; cdecl;
  nk_vec2v: function(const xy: PSingle): nk_vec2; cdecl;
  nk_vec2iv: function(const xy: PInteger): nk_vec2; cdecl;
  nk_get_null_rect: function(): nk_rect; cdecl;
  nk_rect_: function(x: Single; y: Single; w: Single; h: Single): nk_rect; cdecl;
  nk_recti_: function(x: Integer; y: Integer; w: Integer; h: Integer): nk_rect; cdecl;
  nk_recta: function(pos: nk_vec2; size: nk_vec2): nk_rect; cdecl;
  nk_rectv: function(const xywh: PSingle): nk_rect; cdecl;
  nk_rectiv: function(const xywh: PInteger): nk_rect; cdecl;
  nk_rect_pos: function(p1: nk_rect): nk_vec2; cdecl;
  nk_rect_size: function(p1: nk_rect): nk_vec2; cdecl;
  nk_strlen: function(const str: PUTF8Char): Integer; cdecl;
  nk_stricmp: function(const s1: PUTF8Char; const s2: PUTF8Char): Integer; cdecl;
  nk_stricmpn: function(const s1: PUTF8Char; const s2: PUTF8Char; n: Integer): Integer; cdecl;
  nk_strtoi: function(const str: PUTF8Char; endptr: PPUTF8Char): Integer; cdecl;
  nk_strtof: function(const str: PUTF8Char; endptr: PPUTF8Char): Single; cdecl;
  nk_strtod: function(const str: PUTF8Char; endptr: PPUTF8Char): Double; cdecl;
  nk_strfilter: function(const text: PUTF8Char; const regexp: PUTF8Char): Integer; cdecl;
  nk_strmatch_fuzzy_string: function(const str: PUTF8Char; const pattern: PUTF8Char; out_score: PInteger): Integer; cdecl;
  nk_strmatch_fuzzy_text: function(const txt: PUTF8Char; txt_len: Integer; const pattern: PUTF8Char; out_score: PInteger): Integer; cdecl;
  nk_utf_decode: function(const p1: PUTF8Char; p2: Pnk_rune; p3: Integer): Integer; cdecl;
  nk_utf_encode: function(p1: nk_rune; p2: PUTF8Char; p3: Integer): Integer; cdecl;
  nk_utf_len: function(const p1: PUTF8Char; byte_len: Integer): Integer; cdecl;
  nk_utf_at: function(const buffer: PUTF8Char; length: Integer; index: Integer; unicode: Pnk_rune; len: PInteger): PUTF8Char; cdecl;
  nk_buffer_init_default: procedure(p1: Pnk_buffer); cdecl;
  nk_buffer_init: procedure(p1: Pnk_buffer; const p2: Pnk_allocator; size: nk_size); cdecl;
  nk_buffer_init_fixed: procedure(p1: Pnk_buffer; memory: Pointer; size: nk_size); cdecl;
  nk_buffer_info: procedure(p1: Pnk_memory_status; p2: Pnk_buffer); cdecl;
  nk_buffer_push: procedure(p1: Pnk_buffer; &type: nk_buffer_allocation_type; const memory: Pointer; size: nk_size; align: nk_size); cdecl;
  nk_buffer_mark: procedure(p1: Pnk_buffer; &type: nk_buffer_allocation_type); cdecl;
  nk_buffer_reset: procedure(p1: Pnk_buffer; &type: nk_buffer_allocation_type); cdecl;
  nk_buffer_clear: procedure(p1: Pnk_buffer); cdecl;
  nk_buffer_free: procedure(p1: Pnk_buffer); cdecl;
  nk_buffer_memory: function(p1: Pnk_buffer): Pointer; cdecl;
  nk_buffer_memory_const: function(const p1: Pnk_buffer): Pointer; cdecl;
  nk_buffer_total: function(p1: Pnk_buffer): nk_size; cdecl;
  nk_str_init_default: procedure(p1: Pnk_str); cdecl;
  nk_str_init: procedure(p1: Pnk_str; const p2: Pnk_allocator; size: nk_size); cdecl;
  nk_str_init_fixed: procedure(p1: Pnk_str; memory: Pointer; size: nk_size); cdecl;
  nk_str_clear: procedure(p1: Pnk_str); cdecl;
  nk_str_free: procedure(p1: Pnk_str); cdecl;
  nk_str_append_text_char: function(p1: Pnk_str; const p2: PUTF8Char; p3: Integer): Integer; cdecl;
  nk_str_append_str_char: function(p1: Pnk_str; const p2: PUTF8Char): Integer; cdecl;
  nk_str_append_text_utf8: function(p1: Pnk_str; const p2: PUTF8Char; p3: Integer): Integer; cdecl;
  nk_str_append_str_utf8: function(p1: Pnk_str; const p2: PUTF8Char): Integer; cdecl;
  nk_str_append_text_runes: function(p1: Pnk_str; const p2: Pnk_rune; p3: Integer): Integer; cdecl;
  nk_str_append_str_runes: function(p1: Pnk_str; const p2: Pnk_rune): Integer; cdecl;
  nk_str_insert_at_char: function(p1: Pnk_str; pos: Integer; const p3: PUTF8Char; p4: Integer): Integer; cdecl;
  nk_str_insert_at_rune: function(p1: Pnk_str; pos: Integer; const p3: PUTF8Char; p4: Integer): Integer; cdecl;
  nk_str_insert_text_char: function(p1: Pnk_str; pos: Integer; const p3: PUTF8Char; p4: Integer): Integer; cdecl;
  nk_str_insert_str_char: function(p1: Pnk_str; pos: Integer; const p3: PUTF8Char): Integer; cdecl;
  nk_str_insert_text_utf8: function(p1: Pnk_str; pos: Integer; const p3: PUTF8Char; p4: Integer): Integer; cdecl;
  nk_str_insert_str_utf8: function(p1: Pnk_str; pos: Integer; const p3: PUTF8Char): Integer; cdecl;
  nk_str_insert_text_runes: function(p1: Pnk_str; pos: Integer; const p3: Pnk_rune; p4: Integer): Integer; cdecl;
  nk_str_insert_str_runes: function(p1: Pnk_str; pos: Integer; const p3: Pnk_rune): Integer; cdecl;
  nk_str_remove_chars: procedure(p1: Pnk_str; len: Integer); cdecl;
  nk_str_remove_runes: procedure(str: Pnk_str; len: Integer); cdecl;
  nk_str_delete_chars: procedure(p1: Pnk_str; pos: Integer; len: Integer); cdecl;
  nk_str_delete_runes: procedure(p1: Pnk_str; pos: Integer; len: Integer); cdecl;
  nk_str_at_char: function(p1: Pnk_str; pos: Integer): PUTF8Char; cdecl;
  nk_str_at_rune: function(p1: Pnk_str; pos: Integer; unicode: Pnk_rune; len: PInteger): PUTF8Char; cdecl;
  nk_str_rune_at: function(const p1: Pnk_str; pos: Integer): nk_rune; cdecl;
  nk_str_at_char_const: function(const p1: Pnk_str; pos: Integer): PUTF8Char; cdecl;
  nk_str_at_const: function(const p1: Pnk_str; pos: Integer; unicode: Pnk_rune; len: PInteger): PUTF8Char; cdecl;
  nk_str_get: function(p1: Pnk_str): PUTF8Char; cdecl;
  nk_str_get_const: function(const p1: Pnk_str): PUTF8Char; cdecl;
  nk_str_len: function(p1: Pnk_str): Integer; cdecl;
  nk_str_len_char: function(p1: Pnk_str): Integer; cdecl;
  nk_filter_default: function(const p1: Pnk_text_edit; unicode: nk_rune): Integer; cdecl;
  nk_filter_ascii: function(const p1: Pnk_text_edit; unicode: nk_rune): Integer; cdecl;
  nk_filter_float: function(const p1: Pnk_text_edit; unicode: nk_rune): Integer; cdecl;
  nk_filter_decimal: function(const p1: Pnk_text_edit; unicode: nk_rune): Integer; cdecl;
  nk_filter_hex: function(const p1: Pnk_text_edit; unicode: nk_rune): Integer; cdecl;
  nk_filter_oct: function(const p1: Pnk_text_edit; unicode: nk_rune): Integer; cdecl;
  nk_filter_binary: function(const p1: Pnk_text_edit; unicode: nk_rune): Integer; cdecl;
  nk_textedit_init_default: procedure(p1: Pnk_text_edit); cdecl;
  nk_textedit_init: procedure(p1: Pnk_text_edit; p2: Pnk_allocator; size: nk_size); cdecl;
  nk_textedit_init_fixed: procedure(p1: Pnk_text_edit; memory: Pointer; size: nk_size); cdecl;
  nk_textedit_free: procedure(p1: Pnk_text_edit); cdecl;
  nk_textedit_text: procedure(p1: Pnk_text_edit; const p2: PUTF8Char; total_len: Integer); cdecl;
  nk_textedit_delete: procedure(p1: Pnk_text_edit; where: Integer; len: Integer); cdecl;
  nk_textedit_delete_selection: procedure(p1: Pnk_text_edit); cdecl;
  nk_textedit_select_all: procedure(p1: Pnk_text_edit); cdecl;
  nk_textedit_cut: function(p1: Pnk_text_edit): Integer; cdecl;
  nk_textedit_paste: function(p1: Pnk_text_edit; const p2: PUTF8Char; len: Integer): Integer; cdecl;
  nk_textedit_undo: procedure(p1: Pnk_text_edit); cdecl;
  nk_textedit_redo: procedure(p1: Pnk_text_edit); cdecl;
  nk_stroke_line: procedure(b: Pnk_command_buffer; x0: Single; y0: Single; x1: Single; y1: Single; line_thickness: Single; p7: nk_color); cdecl;
  nk_stroke_curve: procedure(p1: Pnk_command_buffer; p2: Single; p3: Single; p4: Single; p5: Single; p6: Single; p7: Single; p8: Single; p9: Single; line_thickness: Single; p11: nk_color); cdecl;
  nk_stroke_rect: procedure(p1: Pnk_command_buffer; p2: nk_rect; rounding: Single; line_thickness: Single; p5: nk_color); cdecl;
  nk_stroke_circle: procedure(p1: Pnk_command_buffer; p2: nk_rect; line_thickness: Single; p4: nk_color); cdecl;
  nk_stroke_arc: procedure(p1: Pnk_command_buffer; cx: Single; cy: Single; radius: Single; a_min: Single; a_max: Single; line_thickness: Single; p8: nk_color); cdecl;
  nk_stroke_triangle: procedure(p1: Pnk_command_buffer; p2: Single; p3: Single; p4: Single; p5: Single; p6: Single; p7: Single; line_thichness: Single; p9: nk_color); cdecl;
  nk_stroke_polyline: procedure(p1: Pnk_command_buffer; points: PSingle; point_count: Integer; line_thickness: Single; col: nk_color); cdecl;
  nk_stroke_polygon: procedure(p1: Pnk_command_buffer; p2: PSingle; point_count: Integer; line_thickness: Single; p5: nk_color); cdecl;
  nk_fill_rect: procedure(p1: Pnk_command_buffer; p2: nk_rect; rounding: Single; p4: nk_color); cdecl;
  nk_fill_rect_multi_color: procedure(p1: Pnk_command_buffer; p2: nk_rect; left: nk_color; top: nk_color; right: nk_color; bottom: nk_color); cdecl;
  nk_fill_circle: procedure(p1: Pnk_command_buffer; p2: nk_rect; p3: nk_color); cdecl;
  nk_fill_arc: procedure(p1: Pnk_command_buffer; cx: Single; cy: Single; radius: Single; a_min: Single; a_max: Single; p7: nk_color); cdecl;
  nk_fill_triangle: procedure(p1: Pnk_command_buffer; x0: Single; y0: Single; x1: Single; y1: Single; x2: Single; y2: Single; p8: nk_color); cdecl;
  nk_fill_polygon: procedure(p1: Pnk_command_buffer; p2: PSingle; point_count: Integer; p4: nk_color); cdecl;
  nk_draw_image: procedure(p1: Pnk_command_buffer; p2: nk_rect; const p3: Pnk_image; p4: nk_color); cdecl;
  nk_draw_text: procedure(p1: Pnk_command_buffer; p2: nk_rect; const text: PUTF8Char; len: Integer; const p5: Pnk_user_font; p6: nk_color; p7: nk_color); cdecl;
  nk_push_scissor: procedure(p1: Pnk_command_buffer; p2: nk_rect); cdecl;
  nk_push_custom: procedure(p1: Pnk_command_buffer; p2: nk_rect; p3: nk_command_custom_callback; usr: nk_handle); cdecl;
  nk_input_has_mouse_click: function(const p1: Pnk_input; p2: nk_buttons): Integer; cdecl;
  nk_input_has_mouse_click_in_rect: function(const p1: Pnk_input; p2: nk_buttons; p3: nk_rect): Integer; cdecl;
  nk_input_has_mouse_click_down_in_rect: function(const p1: Pnk_input; p2: nk_buttons; p3: nk_rect; down: Integer): Integer; cdecl;
  nk_input_is_mouse_click_in_rect: function(const p1: Pnk_input; p2: nk_buttons; p3: nk_rect): Integer; cdecl;
  nk_input_is_mouse_click_down_in_rect: function(const i: Pnk_input; id: nk_buttons; b: nk_rect; down: Integer): Integer; cdecl;
  nk_input_any_mouse_click_in_rect: function(const p1: Pnk_input; p2: nk_rect): Integer; cdecl;
  nk_input_is_mouse_prev_hovering_rect: function(const p1: Pnk_input; p2: nk_rect): Integer; cdecl;
  nk_input_is_mouse_hovering_rect: function(const p1: Pnk_input; p2: nk_rect): Integer; cdecl;
  nk_input_mouse_clicked: function(const p1: Pnk_input; p2: nk_buttons; p3: nk_rect): Integer; cdecl;
  nk_input_is_mouse_down: function(const p1: Pnk_input; p2: nk_buttons): Integer; cdecl;
  nk_input_is_mouse_pressed: function(const p1: Pnk_input; p2: nk_buttons): Integer; cdecl;
  nk_input_is_mouse_released: function(const p1: Pnk_input; p2: nk_buttons): Integer; cdecl;
  nk_input_is_key_pressed: function(const p1: Pnk_input; p2: nk_keys): Integer; cdecl;
  nk_input_is_key_released: function(const p1: Pnk_input; p2: nk_keys): Integer; cdecl;
  nk_input_is_key_down: function(const p1: Pnk_input; p2: nk_keys): Integer; cdecl;
  nk_style_item_image_: function(img: nk_image): nk_style_item; cdecl;
  nk_style_item_color_: function(p1: nk_color): nk_style_item; cdecl;
  nk_style_item_hide: function(): nk_style_item; cdecl;

implementation

{$R Vivace.Nuklear.res}

uses
  System.SysUtils,
  Vivace.Utils,
  Vivace.MemoryModule;

var
  DLL: Pointer;

procedure LoadDLL;
begin
  DLL := LoadResDLL('NUKLEAR');
  if DLL <> nil then
  begin
    @nk_init_default := TMemoryModule.GetProcAddress(DLL, 'nk_init_default');
    @nk_init_fixed := TMemoryModule.GetProcAddress(DLL, 'nk_init_fixed');
    @nk_init := TMemoryModule.GetProcAddress(DLL, 'nk_init');
    @nk_init_custom := TMemoryModule.GetProcAddress(DLL, 'nk_init_custom');
    @nk_clear := TMemoryModule.GetProcAddress(DLL, 'nk_clear');
    @nk_free := TMemoryModule.GetProcAddress(DLL, 'nk_free');
    @nk_input_begin := TMemoryModule.GetProcAddress(DLL, 'nk_input_begin');
    @nk_input_motion := TMemoryModule.GetProcAddress(DLL, 'nk_input_motion');
    @nk_input_key := TMemoryModule.GetProcAddress(DLL, 'nk_input_key');
    @nk_input_button := TMemoryModule.GetProcAddress(DLL, 'nk_input_button');
    @nk_input_scroll := TMemoryModule.GetProcAddress(DLL, 'nk_input_scroll');
    @nk_input_char := TMemoryModule.GetProcAddress(DLL, 'nk_input_char');
    @nk_input_glyph := TMemoryModule.GetProcAddress(DLL, 'nk_input_glyph');
    @nk_input_unicode := TMemoryModule.GetProcAddress(DLL, 'nk_input_unicode');
    @nk_input_end := TMemoryModule.GetProcAddress(DLL, 'nk_input_end');
    @nk__begin := TMemoryModule.GetProcAddress(DLL, 'nk__begin');
    @nk__next := TMemoryModule.GetProcAddress(DLL, 'nk__next');
    @nk_begin := TMemoryModule.GetProcAddress(DLL, 'nk_begin');
    @nk_begin_titled := TMemoryModule.GetProcAddress(DLL, 'nk_begin_titled');
    @nk_end := TMemoryModule.GetProcAddress(DLL, 'nk_end');
    @nk_window_find := TMemoryModule.GetProcAddress(DLL, 'nk_window_find');
    @nk_window_get_bounds := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_bounds');
    @nk_window_get_position := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_position');
    @nk_window_get_size := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_size');
    @nk_window_get_width := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_width');
    @nk_window_get_height := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_height');
    @nk_window_get_panel := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_panel');
    @nk_window_get_content_region := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_content_region');
    @nk_window_get_content_region_min := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_content_region_min');
    @nk_window_get_content_region_max := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_content_region_max');
    @nk_window_get_content_region_size := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_content_region_size');
    @nk_window_get_canvas := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_canvas');
    @nk_window_get_scroll := TMemoryModule.GetProcAddress(DLL, 'nk_window_get_scroll');
    @nk_window_has_focus := TMemoryModule.GetProcAddress(DLL, 'nk_window_has_focus');
    @nk_window_is_hovered := TMemoryModule.GetProcAddress(DLL, 'nk_window_is_hovered');
    @nk_window_is_collapsed := TMemoryModule.GetProcAddress(DLL, 'nk_window_is_collapsed');
    @nk_window_is_closed := TMemoryModule.GetProcAddress(DLL, 'nk_window_is_closed');
    @nk_window_is_hidden := TMemoryModule.GetProcAddress(DLL, 'nk_window_is_hidden');
    @nk_window_is_active := TMemoryModule.GetProcAddress(DLL, 'nk_window_is_active');
    @nk_window_is_any_hovered := TMemoryModule.GetProcAddress(DLL, 'nk_window_is_any_hovered');
    @nk_item_is_any_active := TMemoryModule.GetProcAddress(DLL, 'nk_item_is_any_active');
    @nk_window_set_bounds := TMemoryModule.GetProcAddress(DLL, 'nk_window_set_bounds');
    @nk_window_set_position := TMemoryModule.GetProcAddress(DLL, 'nk_window_set_position');
    @nk_window_set_size := TMemoryModule.GetProcAddress(DLL, 'nk_window_set_size');
    @nk_window_set_focus := TMemoryModule.GetProcAddress(DLL, 'nk_window_set_focus');
    @nk_window_set_scroll := TMemoryModule.GetProcAddress(DLL, 'nk_window_set_scroll');
    @nk_window_close := TMemoryModule.GetProcAddress(DLL, 'nk_window_close');
    @nk_window_collapse := TMemoryModule.GetProcAddress(DLL, 'nk_window_collapse');
    @nk_window_collapse_if := TMemoryModule.GetProcAddress(DLL, 'nk_window_collapse_if');
    @nk_window_show := TMemoryModule.GetProcAddress(DLL, 'nk_window_show');
    @nk_window_show_if := TMemoryModule.GetProcAddress(DLL, 'nk_window_show_if');
    @nk_layout_set_min_row_height := TMemoryModule.GetProcAddress(DLL, 'nk_layout_set_min_row_height');
    @nk_layout_reset_min_row_height := TMemoryModule.GetProcAddress(DLL, 'nk_layout_reset_min_row_height');
    @nk_layout_widget_bounds := TMemoryModule.GetProcAddress(DLL, 'nk_layout_widget_bounds');
    @nk_layout_ratio_from_pixel := TMemoryModule.GetProcAddress(DLL, 'nk_layout_ratio_from_pixel');
    @nk_layout_row_dynamic := TMemoryModule.GetProcAddress(DLL, 'nk_layout_row_dynamic');
    @nk_layout_row_static := TMemoryModule.GetProcAddress(DLL, 'nk_layout_row_static');
    @nk_layout_row_begin := TMemoryModule.GetProcAddress(DLL, 'nk_layout_row_begin');
    @nk_layout_row_push := TMemoryModule.GetProcAddress(DLL, 'nk_layout_row_push');
    @nk_layout_row_end := TMemoryModule.GetProcAddress(DLL, 'nk_layout_row_end');
    @nk_layout_row := TMemoryModule.GetProcAddress(DLL, 'nk_layout_row');
    @nk_layout_row_template_begin := TMemoryModule.GetProcAddress(DLL, 'nk_layout_row_template_begin');
    @nk_layout_row_template_push_dynamic := TMemoryModule.GetProcAddress(DLL, 'nk_layout_row_template_push_dynamic');
    @nk_layout_row_template_push_variable := TMemoryModule.GetProcAddress(DLL, 'nk_layout_row_template_push_variable');
    @nk_layout_row_template_push_static := TMemoryModule.GetProcAddress(DLL, 'nk_layout_row_template_push_static');
    @nk_layout_row_template_end := TMemoryModule.GetProcAddress(DLL, 'nk_layout_row_template_end');
    @nk_layout_space_begin := TMemoryModule.GetProcAddress(DLL, 'nk_layout_space_begin');
    @nk_layout_space_push := TMemoryModule.GetProcAddress(DLL, 'nk_layout_space_push');
    @nk_layout_space_end := TMemoryModule.GetProcAddress(DLL, 'nk_layout_space_end');
    @nk_layout_space_bounds := TMemoryModule.GetProcAddress(DLL, 'nk_layout_space_bounds');
    @nk_layout_space_to_screen := TMemoryModule.GetProcAddress(DLL, 'nk_layout_space_to_screen');
    @nk_layout_space_to_local := TMemoryModule.GetProcAddress(DLL, 'nk_layout_space_to_local');
    @nk_layout_space_rect_to_screen := TMemoryModule.GetProcAddress(DLL, 'nk_layout_space_rect_to_screen');
    @nk_layout_space_rect_to_local := TMemoryModule.GetProcAddress(DLL, 'nk_layout_space_rect_to_local');
    @nk_group_begin := TMemoryModule.GetProcAddress(DLL, 'nk_group_begin');
    @nk_group_begin_titled := TMemoryModule.GetProcAddress(DLL, 'nk_group_begin_titled');
    @nk_group_end := TMemoryModule.GetProcAddress(DLL, 'nk_group_end');
    @nk_group_scrolled_offset_begin := TMemoryModule.GetProcAddress(DLL, 'nk_group_scrolled_offset_begin');
    @nk_group_scrolled_begin := TMemoryModule.GetProcAddress(DLL, 'nk_group_scrolled_begin');
    @nk_group_scrolled_end := TMemoryModule.GetProcAddress(DLL, 'nk_group_scrolled_end');
    @nk_group_get_scroll := TMemoryModule.GetProcAddress(DLL, 'nk_group_get_scroll');
    @nk_group_set_scroll := TMemoryModule.GetProcAddress(DLL, 'nk_group_set_scroll');
    @nk_tree_push_hashed := TMemoryModule.GetProcAddress(DLL, 'nk_tree_push_hashed');
    @nk_tree_image_push_hashed := TMemoryModule.GetProcAddress(DLL, 'nk_tree_image_push_hashed');
    @nk_tree_pop := TMemoryModule.GetProcAddress(DLL, 'nk_tree_pop');
    @nk_tree_state_push := TMemoryModule.GetProcAddress(DLL, 'nk_tree_state_push');
    @nk_tree_state_image_push := TMemoryModule.GetProcAddress(DLL, 'nk_tree_state_image_push');
    @nk_tree_state_pop := TMemoryModule.GetProcAddress(DLL, 'nk_tree_state_pop');
    @nk_tree_element_push_hashed := TMemoryModule.GetProcAddress(DLL, 'nk_tree_element_push_hashed');
    @nk_tree_element_image_push_hashed := TMemoryModule.GetProcAddress(DLL, 'nk_tree_element_image_push_hashed');
    @nk_tree_element_pop := TMemoryModule.GetProcAddress(DLL, 'nk_tree_element_pop');
    @nk_list_view_begin := TMemoryModule.GetProcAddress(DLL, 'nk_list_view_begin');
    @nk_list_view_end := TMemoryModule.GetProcAddress(DLL, 'nk_list_view_end');
    @nk_widget := TMemoryModule.GetProcAddress(DLL, 'nk_widget');
    @nk_widget_fitting := TMemoryModule.GetProcAddress(DLL, 'nk_widget_fitting');
    @nk_widget_bounds := TMemoryModule.GetProcAddress(DLL, 'nk_widget_bounds');
    @nk_widget_position := TMemoryModule.GetProcAddress(DLL, 'nk_widget_position');
    @nk_widget_size := TMemoryModule.GetProcAddress(DLL, 'nk_widget_size');
    @nk_widget_width := TMemoryModule.GetProcAddress(DLL, 'nk_widget_width');
    @nk_widget_height := TMemoryModule.GetProcAddress(DLL, 'nk_widget_height');
    @nk_widget_is_hovered := TMemoryModule.GetProcAddress(DLL, 'nk_widget_is_hovered');
    @nk_widget_is_mouse_clicked := TMemoryModule.GetProcAddress(DLL, 'nk_widget_is_mouse_clicked');
    @nk_widget_has_mouse_click_down := TMemoryModule.GetProcAddress(DLL, 'nk_widget_has_mouse_click_down');
    @nk_spacing := TMemoryModule.GetProcAddress(DLL, 'nk_spacing');
    @nk_text := TMemoryModule.GetProcAddress(DLL, 'nk_text');
    @nk_text_colored := TMemoryModule.GetProcAddress(DLL, 'nk_text_colored');
    @nk_text_wrap := TMemoryModule.GetProcAddress(DLL, 'nk_text_wrap');
    @nk_text_wrap_colored := TMemoryModule.GetProcAddress(DLL, 'nk_text_wrap_colored');
    @nk_label := TMemoryModule.GetProcAddress(DLL, 'nk_label');
    @nk_label_colored := TMemoryModule.GetProcAddress(DLL, 'nk_label_colored');
    @nk_label_wrap := TMemoryModule.GetProcAddress(DLL, 'nk_label_wrap');
    @nk_label_colored_wrap := TMemoryModule.GetProcAddress(DLL, 'nk_label_colored_wrap');
    @nk_image_ := TMemoryModule.GetProcAddress(DLL, 'nk_image_');
    @nk_image_color := TMemoryModule.GetProcAddress(DLL, 'nk_image_color');
    @nk_button_text := TMemoryModule.GetProcAddress(DLL, 'nk_button_text');
    @nk_button_label := TMemoryModule.GetProcAddress(DLL, 'nk_button_label');
    @nk_button_color := TMemoryModule.GetProcAddress(DLL, 'nk_button_color');
    @nk_button_symbol := TMemoryModule.GetProcAddress(DLL, 'nk_button_symbol');
    @nk_button_image := TMemoryModule.GetProcAddress(DLL, 'nk_button_image');
    @nk_button_symbol_label := TMemoryModule.GetProcAddress(DLL, 'nk_button_symbol_label');
    @nk_button_symbol_text := TMemoryModule.GetProcAddress(DLL, 'nk_button_symbol_text');
    @nk_button_image_label := TMemoryModule.GetProcAddress(DLL, 'nk_button_image_label');
    @nk_button_image_text := TMemoryModule.GetProcAddress(DLL, 'nk_button_image_text');
    @nk_button_text_styled := TMemoryModule.GetProcAddress(DLL, 'nk_button_text_styled');
    @nk_button_label_styled := TMemoryModule.GetProcAddress(DLL, 'nk_button_label_styled');
    @nk_button_symbol_styled := TMemoryModule.GetProcAddress(DLL, 'nk_button_symbol_styled');
    @nk_button_image_styled := TMemoryModule.GetProcAddress(DLL, 'nk_button_image_styled');
    @nk_button_symbol_text_styled := TMemoryModule.GetProcAddress(DLL, 'nk_button_symbol_text_styled');
    @nk_button_symbol_label_styled := TMemoryModule.GetProcAddress(DLL, 'nk_button_symbol_label_styled');
    @nk_button_image_label_styled := TMemoryModule.GetProcAddress(DLL, 'nk_button_image_label_styled');
    @nk_button_image_text_styled := TMemoryModule.GetProcAddress(DLL, 'nk_button_image_text_styled');
    @nk_button_set_behavior := TMemoryModule.GetProcAddress(DLL, 'nk_button_set_behavior');
    @nk_button_push_behavior := TMemoryModule.GetProcAddress(DLL, 'nk_button_push_behavior');
    @nk_button_pop_behavior := TMemoryModule.GetProcAddress(DLL, 'nk_button_pop_behavior');
    @nk_check_label := TMemoryModule.GetProcAddress(DLL, 'nk_check_label');
    @nk_check_text := TMemoryModule.GetProcAddress(DLL, 'nk_check_text');
    @nk_check_flags_label := TMemoryModule.GetProcAddress(DLL, 'nk_check_flags_label');
    @nk_check_flags_text := TMemoryModule.GetProcAddress(DLL, 'nk_check_flags_text');
    @nk_checkbox_label := TMemoryModule.GetProcAddress(DLL, 'nk_checkbox_label');
    @nk_checkbox_text := TMemoryModule.GetProcAddress(DLL, 'nk_checkbox_text');
    @nk_checkbox_flags_label := TMemoryModule.GetProcAddress(DLL, 'nk_checkbox_flags_label');
    @nk_checkbox_flags_text := TMemoryModule.GetProcAddress(DLL, 'nk_checkbox_flags_text');
    @nk_radio_label := TMemoryModule.GetProcAddress(DLL, 'nk_radio_label');
    @nk_radio_text := TMemoryModule.GetProcAddress(DLL, 'nk_radio_text');
    @nk_option_label := TMemoryModule.GetProcAddress(DLL, 'nk_option_label');
    @nk_option_text := TMemoryModule.GetProcAddress(DLL, 'nk_option_text');
    @nk_selectable_label := TMemoryModule.GetProcAddress(DLL, 'nk_selectable_label');
    @nk_selectable_text := TMemoryModule.GetProcAddress(DLL, 'nk_selectable_text');
    @nk_selectable_image_label := TMemoryModule.GetProcAddress(DLL, 'nk_selectable_image_label');
    @nk_selectable_image_text := TMemoryModule.GetProcAddress(DLL, 'nk_selectable_image_text');
    @nk_selectable_symbol_label := TMemoryModule.GetProcAddress(DLL, 'nk_selectable_symbol_label');
    @nk_selectable_symbol_text := TMemoryModule.GetProcAddress(DLL, 'nk_selectable_symbol_text');
    @nk_select_label := TMemoryModule.GetProcAddress(DLL, 'nk_select_label');
    @nk_select_text := TMemoryModule.GetProcAddress(DLL, 'nk_select_text');
    @nk_select_image_label := TMemoryModule.GetProcAddress(DLL, 'nk_select_image_label');
    @nk_select_image_text := TMemoryModule.GetProcAddress(DLL, 'nk_select_image_text');
    @nk_select_symbol_label := TMemoryModule.GetProcAddress(DLL, 'nk_select_symbol_label');
    @nk_select_symbol_text := TMemoryModule.GetProcAddress(DLL, 'nk_select_symbol_text');
    @nk_slide_float := TMemoryModule.GetProcAddress(DLL, 'nk_slide_float');
    @nk_slide_int := TMemoryModule.GetProcAddress(DLL, 'nk_slide_int');
    @nk_slider_float := TMemoryModule.GetProcAddress(DLL, 'nk_slider_float');
    @nk_slider_int := TMemoryModule.GetProcAddress(DLL, 'nk_slider_int');
    @nk_progress := TMemoryModule.GetProcAddress(DLL, 'nk_progress');
    @nk_prog := TMemoryModule.GetProcAddress(DLL, 'nk_prog');
    @nk_color_picker := TMemoryModule.GetProcAddress(DLL, 'nk_color_picker');
    @nk_color_pick := TMemoryModule.GetProcAddress(DLL, 'nk_color_pick');
    @nk_property_int := TMemoryModule.GetProcAddress(DLL, 'nk_property_int');
    @nk_property_float := TMemoryModule.GetProcAddress(DLL, 'nk_property_float');
    @nk_property_double := TMemoryModule.GetProcAddress(DLL, 'nk_property_double');
    @nk_propertyi := TMemoryModule.GetProcAddress(DLL, 'nk_propertyi');
    @nk_propertyf := TMemoryModule.GetProcAddress(DLL, 'nk_propertyf');
    @nk_propertyd := TMemoryModule.GetProcAddress(DLL, 'nk_propertyd');
    @nk_edit_string := TMemoryModule.GetProcAddress(DLL, 'nk_edit_string');
    @nk_edit_string_zero_terminated := TMemoryModule.GetProcAddress(DLL, 'nk_edit_string_zero_terminated');
    @nk_edit_buffer := TMemoryModule.GetProcAddress(DLL, 'nk_edit_buffer');
    @nk_edit_focus := TMemoryModule.GetProcAddress(DLL, 'nk_edit_focus');
    @nk_edit_unfocus := TMemoryModule.GetProcAddress(DLL, 'nk_edit_unfocus');
    @nk_chart_begin := TMemoryModule.GetProcAddress(DLL, 'nk_chart_begin');
    @nk_chart_begin_colored := TMemoryModule.GetProcAddress(DLL, 'nk_chart_begin_colored');
    @nk_chart_add_slot := TMemoryModule.GetProcAddress(DLL, 'nk_chart_add_slot');
    @nk_chart_add_slot_colored := TMemoryModule.GetProcAddress(DLL, 'nk_chart_add_slot_colored');
    @nk_chart_push := TMemoryModule.GetProcAddress(DLL, 'nk_chart_push');
    @nk_chart_push_slot := TMemoryModule.GetProcAddress(DLL, 'nk_chart_push_slot');
    @nk_chart_end := TMemoryModule.GetProcAddress(DLL, 'nk_chart_end');
    @nk_plot := TMemoryModule.GetProcAddress(DLL, 'nk_plot');
    @nk_plot_function := TMemoryModule.GetProcAddress(DLL, 'nk_plot_function');
    @nk_popup_begin := TMemoryModule.GetProcAddress(DLL, 'nk_popup_begin');
    @nk_popup_close := TMemoryModule.GetProcAddress(DLL, 'nk_popup_close');
    @nk_popup_end := TMemoryModule.GetProcAddress(DLL, 'nk_popup_end');
    @nk_popup_get_scroll := TMemoryModule.GetProcAddress(DLL, 'nk_popup_get_scroll');
    @nk_popup_set_scroll := TMemoryModule.GetProcAddress(DLL, 'nk_popup_set_scroll');
    @nk_combo := TMemoryModule.GetProcAddress(DLL, 'nk_combo');
    @nk_combo_separator := TMemoryModule.GetProcAddress(DLL, 'nk_combo_separator');
    @nk_combo_string := TMemoryModule.GetProcAddress(DLL, 'nk_combo_string');
    @nk_combo_callback := TMemoryModule.GetProcAddress(DLL, 'nk_combo_callback');
    @nk_combobox := TMemoryModule.GetProcAddress(DLL, 'nk_combobox');
    @nk_combobox_string := TMemoryModule.GetProcAddress(DLL, 'nk_combobox_string');
    @nk_combobox_separator := TMemoryModule.GetProcAddress(DLL, 'nk_combobox_separator');
    @nk_combobox_callback := TMemoryModule.GetProcAddress(DLL, 'nk_combobox_callback');
    @nk_combo_begin_text := TMemoryModule.GetProcAddress(DLL, 'nk_combo_begin_text');
    @nk_combo_begin_label := TMemoryModule.GetProcAddress(DLL, 'nk_combo_begin_label');
    @nk_combo_begin_color := TMemoryModule.GetProcAddress(DLL, 'nk_combo_begin_color');
    @nk_combo_begin_symbol := TMemoryModule.GetProcAddress(DLL, 'nk_combo_begin_symbol');
    @nk_combo_begin_symbol_label := TMemoryModule.GetProcAddress(DLL, 'nk_combo_begin_symbol_label');
    @nk_combo_begin_symbol_text := TMemoryModule.GetProcAddress(DLL, 'nk_combo_begin_symbol_text');
    @nk_combo_begin_image := TMemoryModule.GetProcAddress(DLL, 'nk_combo_begin_image');
    @nk_combo_begin_image_label := TMemoryModule.GetProcAddress(DLL, 'nk_combo_begin_image_label');
    @nk_combo_begin_image_text := TMemoryModule.GetProcAddress(DLL, 'nk_combo_begin_image_text');
    @nk_combo_item_label := TMemoryModule.GetProcAddress(DLL, 'nk_combo_item_label');
    @nk_combo_item_text := TMemoryModule.GetProcAddress(DLL, 'nk_combo_item_text');
    @nk_combo_item_image_label := TMemoryModule.GetProcAddress(DLL, 'nk_combo_item_image_label');
    @nk_combo_item_image_text := TMemoryModule.GetProcAddress(DLL, 'nk_combo_item_image_text');
    @nk_combo_item_symbol_label := TMemoryModule.GetProcAddress(DLL, 'nk_combo_item_symbol_label');
    @nk_combo_item_symbol_text := TMemoryModule.GetProcAddress(DLL, 'nk_combo_item_symbol_text');
    @nk_combo_close := TMemoryModule.GetProcAddress(DLL, 'nk_combo_close');
    @nk_combo_end := TMemoryModule.GetProcAddress(DLL, 'nk_combo_end');
    @nk_contextual_begin := TMemoryModule.GetProcAddress(DLL, 'nk_contextual_begin');
    @nk_contextual_item_text := TMemoryModule.GetProcAddress(DLL, 'nk_contextual_item_text');
    @nk_contextual_item_label := TMemoryModule.GetProcAddress(DLL, 'nk_contextual_item_label');
    @nk_contextual_item_image_label := TMemoryModule.GetProcAddress(DLL, 'nk_contextual_item_image_label');
    @nk_contextual_item_image_text := TMemoryModule.GetProcAddress(DLL, 'nk_contextual_item_image_text');
    @nk_contextual_item_symbol_label := TMemoryModule.GetProcAddress(DLL, 'nk_contextual_item_symbol_label');
    @nk_contextual_item_symbol_text := TMemoryModule.GetProcAddress(DLL, 'nk_contextual_item_symbol_text');
    @nk_contextual_close := TMemoryModule.GetProcAddress(DLL, 'nk_contextual_close');
    @nk_contextual_end := TMemoryModule.GetProcAddress(DLL, 'nk_contextual_end');
    @nk_tooltip := TMemoryModule.GetProcAddress(DLL, 'nk_tooltip');
    @nk_tooltip_begin := TMemoryModule.GetProcAddress(DLL, 'nk_tooltip_begin');
    @nk_tooltip_end := TMemoryModule.GetProcAddress(DLL, 'nk_tooltip_end');
    @nk_menubar_begin := TMemoryModule.GetProcAddress(DLL, 'nk_menubar_begin');
    @nk_menubar_end := TMemoryModule.GetProcAddress(DLL, 'nk_menubar_end');
    @nk_menu_begin_text := TMemoryModule.GetProcAddress(DLL, 'nk_menu_begin_text');
    @nk_menu_begin_label := TMemoryModule.GetProcAddress(DLL, 'nk_menu_begin_label');
    @nk_menu_begin_image := TMemoryModule.GetProcAddress(DLL, 'nk_menu_begin_image');
    @nk_menu_begin_image_text := TMemoryModule.GetProcAddress(DLL, 'nk_menu_begin_image_text');
    @nk_menu_begin_image_label := TMemoryModule.GetProcAddress(DLL, 'nk_menu_begin_image_label');
    @nk_menu_begin_symbol := TMemoryModule.GetProcAddress(DLL, 'nk_menu_begin_symbol');
    @nk_menu_begin_symbol_text := TMemoryModule.GetProcAddress(DLL, 'nk_menu_begin_symbol_text');
    @nk_menu_begin_symbol_label := TMemoryModule.GetProcAddress(DLL, 'nk_menu_begin_symbol_label');
    @nk_menu_item_text := TMemoryModule.GetProcAddress(DLL, 'nk_menu_item_text');
    @nk_menu_item_label := TMemoryModule.GetProcAddress(DLL, 'nk_menu_item_label');
    @nk_menu_item_image_label := TMemoryModule.GetProcAddress(DLL, 'nk_menu_item_image_label');
    @nk_menu_item_image_text := TMemoryModule.GetProcAddress(DLL, 'nk_menu_item_image_text');
    @nk_menu_item_symbol_text := TMemoryModule.GetProcAddress(DLL, 'nk_menu_item_symbol_text');
    @nk_menu_item_symbol_label := TMemoryModule.GetProcAddress(DLL, 'nk_menu_item_symbol_label');
    @nk_menu_close := TMemoryModule.GetProcAddress(DLL, 'nk_menu_close');
    @nk_menu_end := TMemoryModule.GetProcAddress(DLL, 'nk_menu_end');
    @nk_style_default := TMemoryModule.GetProcAddress(DLL, 'nk_style_default');
    @nk_style_from_table := TMemoryModule.GetProcAddress(DLL, 'nk_style_from_table');
    @nk_style_load_cursor := TMemoryModule.GetProcAddress(DLL, 'nk_style_load_cursor');
    @nk_style_load_all_cursors := TMemoryModule.GetProcAddress(DLL, 'nk_style_load_all_cursors');
    @nk_style_get_color_by_name := TMemoryModule.GetProcAddress(DLL, 'nk_style_get_color_by_name');
    @nk_style_set_font := TMemoryModule.GetProcAddress(DLL, 'nk_style_set_font');
    @nk_style_set_cursor := TMemoryModule.GetProcAddress(DLL, 'nk_style_set_cursor');
    @nk_style_show_cursor := TMemoryModule.GetProcAddress(DLL, 'nk_style_show_cursor');
    @nk_style_hide_cursor := TMemoryModule.GetProcAddress(DLL, 'nk_style_hide_cursor');
    @nk_style_push_font := TMemoryModule.GetProcAddress(DLL, 'nk_style_push_font');
    @nk_style_push_float := TMemoryModule.GetProcAddress(DLL, 'nk_style_push_float');
    @nk_style_push_vec2 := TMemoryModule.GetProcAddress(DLL, 'nk_style_push_vec2');
    @nk_style_push_style_item := TMemoryModule.GetProcAddress(DLL, 'nk_style_push_style_item');
    @nk_style_push_flags := TMemoryModule.GetProcAddress(DLL, 'nk_style_push_flags');
    @nk_style_push_color := TMemoryModule.GetProcAddress(DLL, 'nk_style_push_color');
    @nk_style_pop_font := TMemoryModule.GetProcAddress(DLL, 'nk_style_pop_font');
    @nk_style_pop_float := TMemoryModule.GetProcAddress(DLL, 'nk_style_pop_float');
    @nk_style_pop_vec2 := TMemoryModule.GetProcAddress(DLL, 'nk_style_pop_vec2');
    @nk_style_pop_style_item := TMemoryModule.GetProcAddress(DLL, 'nk_style_pop_style_item');
    @nk_style_pop_flags := TMemoryModule.GetProcAddress(DLL, 'nk_style_pop_flags');
    @nk_style_pop_color := TMemoryModule.GetProcAddress(DLL, 'nk_style_pop_color');
    @nk_rgb_ := TMemoryModule.GetProcAddress(DLL, 'nk_rgb_');
    @nk_rgb_iv := TMemoryModule.GetProcAddress(DLL, 'nk_rgb_iv');
    @nk_rgb_bv := TMemoryModule.GetProcAddress(DLL, 'nk_rgb_bv');
    @nk_rgb_f := TMemoryModule.GetProcAddress(DLL, 'nk_rgb_f');
    @nk_rgb_fv := TMemoryModule.GetProcAddress(DLL, 'nk_rgb_fv');
    @nk_rgb_cf := TMemoryModule.GetProcAddress(DLL, 'nk_rgb_cf');
    @nk_rgb_hex := TMemoryModule.GetProcAddress(DLL, 'nk_rgb_hex');
    @nk_rgba_ := TMemoryModule.GetProcAddress(DLL, 'nk_rgba_');
    @nk_rgba_u32 := TMemoryModule.GetProcAddress(DLL, 'nk_rgba_u32');
    @nk_rgba_iv := TMemoryModule.GetProcAddress(DLL, 'nk_rgba_iv');
    @nk_rgba_bv := TMemoryModule.GetProcAddress(DLL, 'nk_rgba_bv');
    @nk_rgba_f := TMemoryModule.GetProcAddress(DLL, 'nk_rgba_f');
    @nk_rgba_fv := TMemoryModule.GetProcAddress(DLL, 'nk_rgba_fv');
    @nk_rgba_cf := TMemoryModule.GetProcAddress(DLL, 'nk_rgba_cf');
    @nk_rgba_hex := TMemoryModule.GetProcAddress(DLL, 'nk_rgba_hex');
    @nk_hsva_colorf := TMemoryModule.GetProcAddress(DLL, 'nk_hsva_colorf');
    @nk_hsva_colorfv := TMemoryModule.GetProcAddress(DLL, 'nk_hsva_colorfv');
    @nk_colorf_hsva_f := TMemoryModule.GetProcAddress(DLL, 'nk_colorf_hsva_f');
    @nk_colorf_hsva_fv := TMemoryModule.GetProcAddress(DLL, 'nk_colorf_hsva_fv');
    @nk_hsv := TMemoryModule.GetProcAddress(DLL, 'nk_hsv');
    @nk_hsv_iv := TMemoryModule.GetProcAddress(DLL, 'nk_hsv_iv');
    @nk_hsv_bv := TMemoryModule.GetProcAddress(DLL, 'nk_hsv_bv');
    @nk_hsv_f := TMemoryModule.GetProcAddress(DLL, 'nk_hsv_f');
    @nk_hsv_fv := TMemoryModule.GetProcAddress(DLL, 'nk_hsv_fv');
    @nk_hsva := TMemoryModule.GetProcAddress(DLL, 'nk_hsva');
    @nk_hsva_iv := TMemoryModule.GetProcAddress(DLL, 'nk_hsva_iv');
    @nk_hsva_bv := TMemoryModule.GetProcAddress(DLL, 'nk_hsva_bv');
    @nk_hsva_f := TMemoryModule.GetProcAddress(DLL, 'nk_hsva_f');
    @nk_hsva_fv := TMemoryModule.GetProcAddress(DLL, 'nk_hsva_fv');
    @nk_color_f := TMemoryModule.GetProcAddress(DLL, 'nk_color_f');
    @nk_color_fv := TMemoryModule.GetProcAddress(DLL, 'nk_color_fv');
    @nk_color_cf := TMemoryModule.GetProcAddress(DLL, 'nk_color_cf');
    @nk_color_d := TMemoryModule.GetProcAddress(DLL, 'nk_color_d');
    @nk_color_dv := TMemoryModule.GetProcAddress(DLL, 'nk_color_dv');
    @nk_color_u32 := TMemoryModule.GetProcAddress(DLL, 'nk_color_u32');
    @nk_color_hex_rgba := TMemoryModule.GetProcAddress(DLL, 'nk_color_hex_rgba');
    @nk_color_hex_rgb := TMemoryModule.GetProcAddress(DLL, 'nk_color_hex_rgb');
    @nk_color_hsv_i := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsv_i');
    @nk_color_hsv_b := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsv_b');
    @nk_color_hsv_iv := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsv_iv');
    @nk_color_hsv_bv := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsv_bv');
    @nk_color_hsv_f := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsv_f');
    @nk_color_hsv_fv := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsv_fv');
    @nk_color_hsva_i := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsva_i');
    @nk_color_hsva_b := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsva_b');
    @nk_color_hsva_iv := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsva_iv');
    @nk_color_hsva_bv := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsva_bv');
    @nk_color_hsva_f := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsva_f');
    @nk_color_hsva_fv := TMemoryModule.GetProcAddress(DLL, 'nk_color_hsva_fv');
    @nk_handle_ptr := TMemoryModule.GetProcAddress(DLL, 'nk_handle_ptr');
    @nk_handle_id := TMemoryModule.GetProcAddress(DLL, 'nk_handle_id');
    @nk_image_handle := TMemoryModule.GetProcAddress(DLL, 'nk_image_handle');
    @nk_image_ptr := TMemoryModule.GetProcAddress(DLL, 'nk_image_ptr');
    @nk_image_id := TMemoryModule.GetProcAddress(DLL, 'nk_image_id');
    @nk_image_is_subimage := TMemoryModule.GetProcAddress(DLL, 'nk_image_is_subimage');
    @nk_subimage_ptr := TMemoryModule.GetProcAddress(DLL, 'nk_subimage_ptr');
    @nk_subimage_id := TMemoryModule.GetProcAddress(DLL, 'nk_subimage_id');
    @nk_subimage_handle := TMemoryModule.GetProcAddress(DLL, 'nk_subimage_handle');
    @nk_murmur_hash := TMemoryModule.GetProcAddress(DLL, 'nk_murmur_hash');
    @nk_triangle_from_direction := TMemoryModule.GetProcAddress(DLL, 'nk_triangle_from_direction');
    @nk_vec2_ := TMemoryModule.GetProcAddress(DLL, 'nk_vec2_');
    @nk_vec2i_ := TMemoryModule.GetProcAddress(DLL, 'nk_vec2i_');
    @nk_vec2v := TMemoryModule.GetProcAddress(DLL, 'nk_vec2v');
    @nk_vec2iv := TMemoryModule.GetProcAddress(DLL, 'nk_vec2iv');
    @nk_get_null_rect := TMemoryModule.GetProcAddress(DLL, 'nk_get_null_rect');
    @nk_rect_ := TMemoryModule.GetProcAddress(DLL, 'nk_rect_');
    @nk_recti_ := TMemoryModule.GetProcAddress(DLL, 'nk_recti_');
    @nk_recta := TMemoryModule.GetProcAddress(DLL, 'nk_recta');
    @nk_rectv := TMemoryModule.GetProcAddress(DLL, 'nk_rectv');
    @nk_rectiv := TMemoryModule.GetProcAddress(DLL, 'nk_rectiv');
    @nk_rect_pos := TMemoryModule.GetProcAddress(DLL, 'nk_rect_pos');
    @nk_rect_size := TMemoryModule.GetProcAddress(DLL, 'nk_rect_size');
    @nk_strlen := TMemoryModule.GetProcAddress(DLL, 'nk_strlen');
    @nk_stricmp := TMemoryModule.GetProcAddress(DLL, 'nk_stricmp');
    @nk_stricmpn := TMemoryModule.GetProcAddress(DLL, 'nk_stricmpn');
    @nk_strtoi := TMemoryModule.GetProcAddress(DLL, 'nk_strtoi');
    @nk_strtof := TMemoryModule.GetProcAddress(DLL, 'nk_strtof');
    @nk_strtod := TMemoryModule.GetProcAddress(DLL, 'nk_strtod');
    @nk_strfilter := TMemoryModule.GetProcAddress(DLL, 'nk_strfilter');
    @nk_strmatch_fuzzy_string := TMemoryModule.GetProcAddress(DLL, 'nk_strmatch_fuzzy_string');
    @nk_strmatch_fuzzy_text := TMemoryModule.GetProcAddress(DLL, 'nk_strmatch_fuzzy_text');
    @nk_utf_decode := TMemoryModule.GetProcAddress(DLL, 'nk_utf_decode');
    @nk_utf_encode := TMemoryModule.GetProcAddress(DLL, 'nk_utf_encode');
    @nk_utf_len := TMemoryModule.GetProcAddress(DLL, 'nk_utf_len');
    @nk_utf_at := TMemoryModule.GetProcAddress(DLL, 'nk_utf_at');
    @nk_buffer_init_default := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_init_default');
    @nk_buffer_init := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_init');
    @nk_buffer_init_fixed := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_init_fixed');
    @nk_buffer_info := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_info');
    @nk_buffer_push := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_push');
    @nk_buffer_mark := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_mark');
    @nk_buffer_reset := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_reset');
    @nk_buffer_clear := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_clear');
    @nk_buffer_free := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_free');
    @nk_buffer_memory := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_memory');
    @nk_buffer_memory_const := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_memory_const');
    @nk_buffer_total := TMemoryModule.GetProcAddress(DLL, 'nk_buffer_total');
    @nk_str_init_default := TMemoryModule.GetProcAddress(DLL, 'nk_str_init_default');
    @nk_str_init := TMemoryModule.GetProcAddress(DLL, 'nk_str_init');
    @nk_str_init_fixed := TMemoryModule.GetProcAddress(DLL, 'nk_str_init_fixed');
    @nk_str_clear := TMemoryModule.GetProcAddress(DLL, 'nk_str_clear');
    @nk_str_free := TMemoryModule.GetProcAddress(DLL, 'nk_str_free');
    @nk_str_append_text_char := TMemoryModule.GetProcAddress(DLL, 'nk_str_append_text_char');
    @nk_str_append_str_char := TMemoryModule.GetProcAddress(DLL, 'nk_str_append_str_char');
    @nk_str_append_text_utf8 := TMemoryModule.GetProcAddress(DLL, 'nk_str_append_text_utf8');
    @nk_str_append_str_utf8 := TMemoryModule.GetProcAddress(DLL, 'nk_str_append_str_utf8');
    @nk_str_append_text_runes := TMemoryModule.GetProcAddress(DLL, 'nk_str_append_text_runes');
    @nk_str_append_str_runes := TMemoryModule.GetProcAddress(DLL, 'nk_str_append_str_runes');
    @nk_str_insert_at_char := TMemoryModule.GetProcAddress(DLL, 'nk_str_insert_at_char');
    @nk_str_insert_at_rune := TMemoryModule.GetProcAddress(DLL, 'nk_str_insert_at_rune');
    @nk_str_insert_text_char := TMemoryModule.GetProcAddress(DLL, 'nk_str_insert_text_char');
    @nk_str_insert_str_char := TMemoryModule.GetProcAddress(DLL, 'nk_str_insert_str_char');
    @nk_str_insert_text_utf8 := TMemoryModule.GetProcAddress(DLL, 'nk_str_insert_text_utf8');
    @nk_str_insert_str_utf8 := TMemoryModule.GetProcAddress(DLL, 'nk_str_insert_str_utf8');
    @nk_str_insert_text_runes := TMemoryModule.GetProcAddress(DLL, 'nk_str_insert_text_runes');
    @nk_str_insert_str_runes := TMemoryModule.GetProcAddress(DLL, 'nk_str_insert_str_runes');
    @nk_str_remove_chars := TMemoryModule.GetProcAddress(DLL, 'nk_str_remove_chars');
    @nk_str_remove_runes := TMemoryModule.GetProcAddress(DLL, 'nk_str_remove_runes');
    @nk_str_delete_chars := TMemoryModule.GetProcAddress(DLL, 'nk_str_delete_chars');
    @nk_str_delete_runes := TMemoryModule.GetProcAddress(DLL, 'nk_str_delete_runes');
    @nk_str_at_char := TMemoryModule.GetProcAddress(DLL, 'nk_str_at_char');
    @nk_str_at_rune := TMemoryModule.GetProcAddress(DLL, 'nk_str_at_rune');
    @nk_str_rune_at := TMemoryModule.GetProcAddress(DLL, 'nk_str_rune_at');
    @nk_str_at_char_const := TMemoryModule.GetProcAddress(DLL, 'nk_str_at_char_const');
    @nk_str_at_const := TMemoryModule.GetProcAddress(DLL, 'nk_str_at_const');
    @nk_str_get := TMemoryModule.GetProcAddress(DLL, 'nk_str_get');
    @nk_str_get_const := TMemoryModule.GetProcAddress(DLL, 'nk_str_get_const');
    @nk_str_len := TMemoryModule.GetProcAddress(DLL, 'nk_str_len');
    @nk_str_len_char := TMemoryModule.GetProcAddress(DLL, 'nk_str_len_char');
    @nk_filter_default := TMemoryModule.GetProcAddress(DLL, 'nk_filter_default');
    @nk_filter_ascii := TMemoryModule.GetProcAddress(DLL, 'nk_filter_ascii');
    @nk_filter_float := TMemoryModule.GetProcAddress(DLL, 'nk_filter_float');
    @nk_filter_decimal := TMemoryModule.GetProcAddress(DLL, 'nk_filter_decimal');
    @nk_filter_hex := TMemoryModule.GetProcAddress(DLL, 'nk_filter_hex');
    @nk_filter_oct := TMemoryModule.GetProcAddress(DLL, 'nk_filter_oct');
    @nk_filter_binary := TMemoryModule.GetProcAddress(DLL, 'nk_filter_binary');
    @nk_textedit_init_default := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_init_default');
    @nk_textedit_init := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_init');
    @nk_textedit_init_fixed := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_init_fixed');
    @nk_textedit_free := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_free');
    @nk_textedit_text := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_text');
    @nk_textedit_delete := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_delete');
    @nk_textedit_delete_selection := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_delete_selection');
    @nk_textedit_select_all := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_select_all');
    @nk_textedit_cut := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_cut');
    @nk_textedit_paste := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_paste');
    @nk_textedit_undo := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_undo');
    @nk_textedit_redo := TMemoryModule.GetProcAddress(DLL, 'nk_textedit_redo');
    @nk_stroke_line := TMemoryModule.GetProcAddress(DLL, 'nk_stroke_line');
    @nk_stroke_curve := TMemoryModule.GetProcAddress(DLL, 'nk_stroke_curve');
    @nk_stroke_rect := TMemoryModule.GetProcAddress(DLL, 'nk_stroke_rect');
    @nk_stroke_circle := TMemoryModule.GetProcAddress(DLL, 'nk_stroke_circle');
    @nk_stroke_arc := TMemoryModule.GetProcAddress(DLL, 'nk_stroke_arc');
    @nk_stroke_triangle := TMemoryModule.GetProcAddress(DLL, 'nk_stroke_triangle');
    @nk_stroke_polyline := TMemoryModule.GetProcAddress(DLL, 'nk_stroke_polyline');
    @nk_stroke_polygon := TMemoryModule.GetProcAddress(DLL, 'nk_stroke_polygon');
    @nk_fill_rect := TMemoryModule.GetProcAddress(DLL, 'nk_fill_rect');
    @nk_fill_rect_multi_color := TMemoryModule.GetProcAddress(DLL, 'nk_fill_rect_multi_color');
    @nk_fill_circle := TMemoryModule.GetProcAddress(DLL, 'nk_fill_circle');
    @nk_fill_arc := TMemoryModule.GetProcAddress(DLL, 'nk_fill_arc');
    @nk_fill_triangle := TMemoryModule.GetProcAddress(DLL, 'nk_fill_triangle');
    @nk_fill_polygon := TMemoryModule.GetProcAddress(DLL, 'nk_fill_polygon');
    @nk_draw_image := TMemoryModule.GetProcAddress(DLL, 'nk_draw_image');
    @nk_draw_text := TMemoryModule.GetProcAddress(DLL, 'nk_draw_text');
    @nk_push_scissor := TMemoryModule.GetProcAddress(DLL, 'nk_push_scissor');
    @nk_push_custom := TMemoryModule.GetProcAddress(DLL, 'nk_push_custom');
    @nk_input_has_mouse_click := TMemoryModule.GetProcAddress(DLL, 'nk_input_has_mouse_click');
    @nk_input_has_mouse_click_in_rect := TMemoryModule.GetProcAddress(DLL, 'nk_input_has_mouse_click_in_rect');
    @nk_input_has_mouse_click_down_in_rect := TMemoryModule.GetProcAddress(DLL, 'nk_input_has_mouse_click_down_in_rect');
    @nk_input_is_mouse_click_in_rect := TMemoryModule.GetProcAddress(DLL, 'nk_input_is_mouse_click_in_rect');
    @nk_input_is_mouse_click_down_in_rect := TMemoryModule.GetProcAddress(DLL, 'nk_input_is_mouse_click_down_in_rect');
    @nk_input_any_mouse_click_in_rect := TMemoryModule.GetProcAddress(DLL, 'nk_input_any_mouse_click_in_rect');
    @nk_input_is_mouse_prev_hovering_rect := TMemoryModule.GetProcAddress(DLL, 'nk_input_is_mouse_prev_hovering_rect');
    @nk_input_is_mouse_hovering_rect := TMemoryModule.GetProcAddress(DLL, 'nk_input_is_mouse_hovering_rect');
    @nk_input_mouse_clicked := TMemoryModule.GetProcAddress(DLL, 'nk_input_mouse_clicked');
    @nk_input_is_mouse_down := TMemoryModule.GetProcAddress(DLL, 'nk_input_is_mouse_down');
    @nk_input_is_mouse_pressed := TMemoryModule.GetProcAddress(DLL, 'nk_input_is_mouse_pressed');
    @nk_input_is_mouse_released := TMemoryModule.GetProcAddress(DLL, 'nk_input_is_mouse_released');
    @nk_input_is_key_pressed := TMemoryModule.GetProcAddress(DLL, 'nk_input_is_key_pressed');
    @nk_input_is_key_released := TMemoryModule.GetProcAddress(DLL, 'nk_input_is_key_released');
    @nk_input_is_key_down := TMemoryModule.GetProcAddress(DLL, 'nk_input_is_key_down');
    @nk_style_item_image_ := TMemoryModule.GetProcAddress(DLL, 'nk_style_item_image_');
    @nk_style_item_color_ := TMemoryModule.GetProcAddress(DLL, 'nk_style_item_color_');
    @nk_style_item_hide := TMemoryModule.GetProcAddress(DLL, 'nk_style_item_hide');
  end;
end;

procedure UnloadDLL;
begin
  TMemoryModule.FreeLibrary(DLL);
end;

initialization
begin
  LoadDLL;
end;

finalization
begin
  UnloadDLL;
end;

end.
