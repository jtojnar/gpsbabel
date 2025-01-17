#
# This project extracts the strings from the command line tool
# that the GUI translates and updates the translation files for
# these strings.
#
CONFIG += console
CONFIG -= app_bundle

QT -= gui
QT += core \
      widgets

TEMPLATE = app

DESTDIR=objects
OBJECTS_DIR=objects
# trick qmake into making objects directory by listing it as MOC_DIR.
MOC_DIR=objects

DEFINES += GENERATE_CORE_STRINGS

INCLUDEPATH += ..
SOURCES += ../formatload.cc
SOURCES += coretool.cc

HEADERS += ../format.h
HEADERS += ../formatload.h

core_strings.target = core_strings.h
core_strings.depends = $(TARGET)
core_strings.depends += ../../gpsbabel
core_strings.commands = $(COPY_FILE) ../../gpsbabel $(DESTDIR)gpsbabel &&
core_strings.commands += ./$(TARGET) core_strings.h;
QMAKE_EXTRA_TARGETS += core_strings
QMAKE_DISTCLEAN += $(DESTDIR)gpsbabel

# The line numbers are almost meaningless the way we generate corestrings.h, and we force everything to the same context.
# With line numbers and the similartext heuristic enabled translations can be copied from an old message to a new message,
# and marked as unfinished.  The threshold for similar is low.
# These will be used by the application, even though they really need to be checked.
# Disable the similartext heuristic to avoid these mistranslations.
qtPrepareTool(LUPDATE, lupdate)
update.depends = core_strings.h
update.commands = $$LUPDATE -disable-heuristic similartext core.pro
QMAKE_EXTRA_TARGETS += update

qtPrepareTool(LRELEASE, lrelease)
release.depends = update
release.commands = $$LRELEASE core.pro
QMAKE_EXTRA_TARGETS += release

