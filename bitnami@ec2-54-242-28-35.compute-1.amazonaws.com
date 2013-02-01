<?xml version="1.0" encoding="UTF-8" ?>
<!--
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements.  See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->

<!-- If this file is found in the config directory, it will only be
     loaded once at startup.  If it is found in Solr's data
     directory, it will be re-loaded every commit.
-->

<elevate>
 <query text="foo bar">
  <doc id="1" />
  <doc id="2" />
  <doc id="3" />
 </query>
 
 <query text="ipod">
   <doc id="MA147LL/A" />  <!-- put the actual ipod at the top -->
   <doc id="IW-02" exclude="true" /> <!-- exclude this cable -->
 </query>
 
</elevate>
