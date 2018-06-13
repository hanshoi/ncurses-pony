use "lib:ncurses"

primitive CWindow

primitive Curses
  // Windows
  fun initscr(): Window =>
    Window.initscr(@initscr[Pointer[CWindow]]())
    
  fun endwin() => @endwin[None]()
  fun newwin(lines: I32 = 60, columns: I32 = 80, y: I32 = 0, x: I32 = 0): Window =>
    Window.create(lines, columns, y, x)

  // Initialization
  fun noecho() => @noecho[None]()
  fun cbreak() => @cbreak[None]()
  fun curs_set(option: I32) => @curs_set[None](option)

  // State changes
  fun clear() => @clear[None]()
  fun refresh() => @refresh[None]()
  fun erase(row: I32, column: I32) => @erase[None](row, column)

  // Output
  fun printw(s: String) => @printw[None](s.cstring())
  fun mvprintw(row: I32, column: I32, s: String) =>
    @mvprintw[None](row, column, s.cstring())
  fun mvaddch(row: I32, column: I32, char_string: String) =>
    try
      let char = char_string.array()(0)?
      @mvaddch[None](row, column, char)
    end

  // Input
  fun getch(): I32 => @getch[I32]()
  fun move(x: I32, y: I32) => @move[None](x,y)

  // Color
  fun start_color() => @start_color[None]()
  fun init_pair(pair_id: I32, foreground: I32, background: I32) =>
    @init_pair[None](pair_id, foreground, background)

  fun switch_on_pair(id: I32) => @attron[None](id << 8)
  fun switch_off_pair(id: I32) => @attroff[None](id << 8)


class Window
  let _cwindow: Pointer[CWindow]

  new create(lines: I32 = 60, columns: I32 = 80, y: I32 = 0, x: I32 = 0) =>
    _cwindow = @newwin[Pointer[CWindow]](lines, columns, y, x)

  new initscr(window: Pointer[CWindow]) =>
    _cwindow = window
    
  fun dispose() =>
    delwin()
    
  fun delwin() =>
    @delwin[None](_cwindow)

  fun keypad(flag: Bool) =>
    @keypad[None](_cwindow, flag)

  fun clear() =>
    @wclear[None](_cwindow)

  fun refresh() =>
    @wrefresh[None](_cwindow)

  fun printw(s: String) =>
    @wprintw[None](_cwindow, s.cstring())

  fun mvprintw(row: I32, column: I32, s: String) =>
    @mvwprintw[None](_cwindow, row, column, s.cstring())

  fun mvaddch(row: I32, column: I32, char: U8) =>
    @mvwaddch[None](_cwindow, row, column, char)

  fun border(left: U8 = ' ', right: U8 = ' ', top: U8 = ' ', bottom: U8 = ' ',
      top_left: U8 = ' ', top_right: U8 = ' ', bottom_left: U8 = ' ',
      bottom_right: U8 = ' ') =>
    
    @wborder[None](_cwindow, left, right, top, bottom, top_left,
      top_right, bottom_left, bottom_right)

  fun move(row: I32, column: I32) =>
    @wmove[None](_cwindow, row, column)

  fun getyx(): (I32, I32) =>
    var row: I32 = 0
    var column: I32 = 0
    @getyx[None](_cwindow, row, column)
    (row, column)

  fun switch_on_pair(id: I32) =>
    @wattron[None](_cwindow, id << 8)

  fun switch_off_pair(id: I32) =>
    @wattroff[None](_cwindow, id << 8)

