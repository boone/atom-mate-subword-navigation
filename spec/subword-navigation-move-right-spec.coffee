fs = require 'fs-plus'
path = require 'path'
temp = require 'temp'
{WorkspaceView} = require 'atom'

describe 'SubwordNavigation', ->
  [editor, buffer] = []

  beforeEach ->
    directory = temp.mkdirSync()
    atom.project.setPath(directory)
    atom.workspaceView = new WorkspaceView()
    atom.workspace = atom.workspaceView.model
    filePath = path.join(directory, 'example.rb')

    waitsForPromise ->
      atom.workspace.open(filePath).then (e) ->
        editor = e
        buffer = editor.getBuffer()

    waitsForPromise ->
      atom.packages.activatePackage('language-ruby')

    waitsForPromise ->
      atom.packages.activatePackage('subword-navigation')

  describe 'move-right', ->
    it 'does not change an empty file', ->
      atom.workspaceView.trigger 'subword-navigation:move-right'
      cursorPosition = editor.getCursorBufferPosition()
      expect(cursorPosition.row).toBe 0
      expect(cursorPosition.column).toBe 0

    it "on blank line, before '\n'", ->
      editor.insertText("\n")
      editor.moveCursorUp 1
      atom.workspaceView.trigger 'subword-navigation:move-right'
      cursorPosition = editor.getCursorBufferPosition()
      expect(cursorPosition.row).toBe 1
      expect(cursorPosition.column).toBe 0

    describe "on '.word.'", ->
      it "when cursor is in the middle", ->
        editor.insertText(".word.\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...2]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 5

    describe "on 'getPreviousWord '", ->
      it "when cursor is at the beginning", ->
        editor.insertText("getPreviousWord \n")
        editor.moveCursorUp 1
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

      it "when cursor is at end of first subword", ->
        editor.insertText("getPreviousWord \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...3]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 11

      it "when cursor is at end of second subword", ->
        editor.insertText("getPreviousWord \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...11]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 15

    describe "on 'sub_word '", ->
      it "when cursor is at the beginning", ->
        editor.insertText("sub_word \n")
        editor.moveCursorUp 1
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

      it "when cursor is at end of first subword", ->
        editor.insertText("sub_word \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...3]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4

      it "when cursor is at the beginnig of second subword", ->
        editor.insertText("sub_word \n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...4]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 8

    describe "on ', =>'", ->
      it "when cursor is at the beginning", ->
        editor.insertText(", =>\n")
        editor.moveCursorUp 1
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 1

      it "when cursor is at end of a comma", ->
        editor.insertText(", =>\n")
        editor.moveCursorUp 1
        editor.moveCursorRight()
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 4

      it "when cursor is at new line", ->
        editor.insertText(", =>\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...4]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 1
        expect(cursorPosition.column).toBe 0

    describe "on '  @var'", ->
      it "when cursor is at the beginning", ->
        editor.insertText("  @var\n")
        editor.moveCursorUp 1
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

    describe "on '()'", ->
      it "when cursor is at the beginning", ->
        editor.insertText("()\n")
        editor.moveCursorUp 1
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2

    describe "on ' - b'", ->
      it "when cursor is at the beginning", ->
        editor.insertText(" - b\n")
        editor.moveCursorUp 1
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 2

      it "when cursor is at end of -", ->
        editor.insertText(" - b\n")
        editor.moveCursorUp 1
        editor.moveCursorRight() for n in [0...2]
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPosition = editor.getCursorBufferPosition()
        expect(cursorPosition.row).toBe 0
        expect(cursorPosition.column).toBe 3

    describe "when 2 cursors", ->
      it "when cursor is at the beginning", ->
        editor.insertText("cursorOptions\ncursorOptions\n")
        editor.moveCursorUp 1
        editor.addCursorAtBufferPosition([0,0])
        atom.workspaceView.trigger 'subword-navigation:move-right'
        cursorPositions = (c.getScreenPosition() for c in editor.getCursors())
        expect(cursorPositions[0].row).toBe 1
        expect(cursorPositions[0].column).toBe 6
        expect(cursorPositions[1].row).toBe 0
        expect(cursorPositions[1].column).toBe 6