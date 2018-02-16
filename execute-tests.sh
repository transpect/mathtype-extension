#!/usr/bin/env bash
export SAXON_CP=saxon/saxon9he.jar
xspec-master/bin/xspec.sh xspec/combine-elements.xspec
grep 'class="failed"' xspec/xspec/combine-elements-result.html >/dev/null 2>&1
test ! $? -eq 0
