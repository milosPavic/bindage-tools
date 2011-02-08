package com.overstock.bindme.impl {
import com.overstock.bindme.IPipeline;

public class MultiPipeline extends Pipeline {
  private var sources:Array;

  public function MultiPipeline( sources:Array ) {
    this.sources = sources;
  }

  override protected function pipelineRunner( pipeline:Function ):Function {
    var args:Array = new Array(sources.length);

    function pipelineRunner():void {
      pipeline(args.slice());
    }

    var runner:Function = pipelineRunner;

    for (var i:int = 0; i < sources.length; i++) {
      var source:IPipeline = sources[i];

      var setArg:Function = setArgPipeline(argSetter(args, i), runner);
      runner = source.runner(setArg);
    }

    return runner;
  }

  override public function watch( handler:Function ):void {
    for each (var source:IPipeline in sources) {
      source.watch(handler);
    }
  }

  private static function setArgPipeline( setArgument:Function,
                                          nextStep:Function ):Function {
    return function( value:* ):void {
      setArgument(value);
      nextStep();
    };
  }

  private static function argSetter( args:Array,
                                     index:int ):Function {
    return function( value:* ):void {
      args[index] = value;
    }
  }

}

}
