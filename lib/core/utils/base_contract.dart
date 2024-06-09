abstract class BaseContract<Ret, Params> {
  Ret call(Params params);
}

abstract class BaseCommand<Ret, Params> extends BaseContract<Ret, Params> {}

abstract class BaseQuery<Ret, Params> extends BaseContract<Ret, Params> {}
