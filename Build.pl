#!/usr/bin/perl
use warnings;
use strict;

use SetupEnv;
use File::Copy;
use File::Find;
use Cwd;
use Cwd 'abs_path';
use Carp;
use XmosBuildLib;
use XmosArg;

my $MAKE_FLAGS;
my $CONFIG;
my $HOST;
my $DOMAIN;
my $BIN;

my %ALIASES =
  (
    'all' => ['clean', 'build', 'install'],
  );

my %TARGETS =
  (
    'clean' => [\&DoClean, "Clean libs"],
    'build' => [\&DoBuild, "Build libs"],
    'install' => [\&DoInstall, "Install libs"],
  );

sub main
{
  my $xmosArg = XmosArg::new(\@ARGV);
  SetupEnv::SetupPaths();

  my @targets =
    sort { XmosBuildLib::ByTarget($a, $b) }
      (@{ $xmosArg->GetTargets() });

  $MAKE_FLAGS = $xmosArg->GetMakeFlags();
  $CONFIG = $xmosArg->GetOption("CONFIG");
  $DOMAIN = $xmosArg->GetOption("DOMAIN");
  $HOST = $xmosArg->GetOption("HOST");
  $BIN = $xmosArg->GetBinDir();

  foreach my $target (@targets) {
    DoTarget($target);
  }
  return 0;
}

sub DoTarget
{
  my $target = $_[0];
  if ($target eq "list_targets") {
    ListTargets();
  } else {
    my $targets = $ALIASES{$target};
    if (defined($targets)) {

      # Target is an alias
      foreach my $target (@$targets) {
        DoTarget($target);
      }
    } else {
      my $function = $TARGETS{$target}[0];
      if (defined($function)) {
        print(" ++ $target\n");
        &$function();
      }
    }
  }
}

sub ListTargets
{
  foreach my $target (keys(%TARGETS)) {
    print("$target\n");
  }
  foreach my $alias (keys(%ALIASES)) {
    print("$alias\n");
  }
}

sub PrintUsage
{
  my $target;
  my $alias;
  my $targets;
  my $targetTable;
  my $description;

  print("Usage:\n");
  print("   Build.pl targets\n");
  print("\n");
  print("   Available targets:\n");
  while (($target, $targetTable) = each(%TARGETS)) {
    $description = @$targetTable[1];
    print("   $target - $description\n");
  }
  while (($alias, $targets) = each(%ALIASES)) {
    $description = "does";
    foreach $target (@$targets) {
      $description = "$description \'$target\' ";
    }
    print("   $alias - $description\n");
  }
  print("   list_targets - List all targets\n");
  exit(1);
}

sub DoClean
{
  chdir($LIB_LOCKS) or confess("Failed to change directory to $LIB_LOCKS");
  XmosBuildLib::RunCommand("xmake clean");
  if ($? != 0) {
    die("Failed to clean liblocks");
  }
}

sub DoBuild
{
  chdir($LIB_LOCKS) or confess("Failed to change directory to $LIB_LOCKS");
  XmosBuildLib::RunCommand("xmake all");
  if ($? != 0) {
    die("Failed to build liblocks");
  }
}

sub DoInstall
{
  XmosBuildLib::InstallXccLibrary("$DOMAIN", "lib_locks${SLASH}lib${SLASH}xs2a", "liblocks.a", "xs2a");
  XmosBuildLib::InstallXccLibrary("$DOMAIN", "lib_locks${SLASH}lib${SLASH}xs1b", "liblocks.a", "xs1b");
  XmosBuildLib::InstallXccHeader($DOMAIN, "lib_locks${SLASH}api", "hwlock.h");
  XmosBuildLib::InstallXccHeader($DOMAIN, "lib_locks${SLASH}api", "swlock.h");
}

main()
