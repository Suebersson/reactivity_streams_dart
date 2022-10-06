import 'dart:async';

// Exemplos de Programação reativa

//https://www.reactivemanifesto.org/pt-BR

void main(){

  //testeStreamWithSigleData();
  //testeStreamFromIterable();
  //testeStreamUnlimitedPeriod();
  //testeStreamPeriodic();

  // A partir desse ponto, nos proporciona mais recurso e posibilidades de aplicação
  //testeMultiStream();
  //testeWithStreamController();
  testeWithStreamControllerBroadCast();
}

//Cria um fluxo que emite um único evento de dados antes de fechar
void testeStreamWithSigleData() async {
  
  int _data = 0;

  final Stream<int> x = Stream<int>.value(++_data);
  
  StreamSubscription<int> listen = x.listen(
    (data) {// onData
      print('$data');
    }
  );

  await Future.delayed(
    Duration(seconds: 3),
    (){
      listen.cancel();
      print('---- testeStreamWithSigleData finish ----');
    }
  );

}


// criar uma stream com uma lista(array) de dados 
void testeStreamFromIterable() async {
  
  int _data = 0;

  final Stream<int> x = Stream<int>.fromIterable(List.generate(10, (index) => index));// [0, 1, 2, ...]

  StreamSubscription<int> listen = x.listen(
    (data) {// onData
      print('$data');
    }
  );

  await Future.delayed(
    Duration(seconds: 3),
    (){
      listen.cancel();
      print('---- testeStreamWithSigleData finish ----');
    }
  );

}


// criar uma stream contadora ilimitada
void testeStreamUnlimitedPeriod () {

  int _data = 0;

  final Stream<int> x = Stream<int>.periodic(
    Duration(seconds: 2), (index) => _data++,
  );

  StreamSubscription<int> listen = x.listen(
    (data) {// onData
      print('$data');
    }
  );

}


// criar uma stream contadora limitada a 10 contagens
void testeStreamPeriodic () {

  int _data = 0;
  final int endData = 10;
  
  late StreamSubscription<int> listen;

  final Stream<int> x = Stream<int>.periodic(
    //Duration(seconds: 2), (index) => _data++,
    Duration(seconds: 2), (index) {
      if(_data <= endData){
        return ++_data;
      }else{
        listen.cancel();
        print('---- finish ----');
        return 0;
      }
    },

  ).take(endData);// gerar 10 números

  listen = x.listen(
    (data) {// onData
      print('$data');
    }
  );

}


// Código útil para monitoramento de dados recebidos
void testeMultiStream(){
  
  int _data = 0;
  late StreamSubscription<int> listen;

  final Stream<int> x = Stream<int>.multi((controller) { 
    Timer.periodic(Duration(seconds: 2), (timer) {// executar algo a cada 2 segundos
      
      if(_data == 11){
        listen.pause();
        print('---- ouvinte pausado ----');
        _data++;
      }else if(_data == 19){
        listen.resume();
        print('---- ouvinte em funcionamento ----');
        _data++;
      }else if(_data > 11 && _data < 19){
        print('---- none ----');
        _data++;
      }else if(_data <= 30){// imprimir apenas os intervalos 0 - 10 e 20 -30
        controller.add(_data++);
      }else{
        timer.cancel();
        listen.cancel();
        controller.sink.close();
        controller.close();
        print('---- Stream disposed ----');
      }

    });
  });

  listen = x.listen(
    (data) {// onData
      print('$data');
    }
  );

}


// declarando uma variável tipo StreamController, faz a mesma coisa que a função [testeMultiStream]
// a diferença é que ao criar uma controller, ela pode ser acessada de qualque lugar da app e ter apenas um listen
void testeWithStreamController () {

  final StreamController<int> controller = StreamController<int>();

  int _data = 0;
  late StreamSubscription<int> listen;

    Timer.periodic(Duration(seconds: 2), (timer) {// executar algo a cada 2 segundos
      
      if(_data == 11){
        listen.pause();
        print('---- ouvinte pausado ----');
        _data++;
      }else if(_data == 19){
        listen.resume();
        print('---- ouvinte em funcionamento ----');
        _data++;
      }else if(_data > 11 && _data < 19){
        print('---- none ----');
        _data++;
      }else if(_data <= 30){// imprimir apenas os intervalos 0 - 10 e 20 -30
        controller.add(_data++);
      }else{
        timer.cancel();
        listen.cancel();
        controller.sink.close();
        controller.close();
        print('---- Stream disposed ----');
      }

    });

  listen = controller.stream.listen(
    (data) {// onData
      print('$data');
    },
    onError: (_) => print('---- execute algo se ocorre algum erro'),
  );

}

// declarando uma variável tipo StreamController.broadCast, faz a mesma coisa que a função [testeMultiStream]
// a diferença é que ao criar uma controller, ela pode ser acessada de qualque lugar da app e ter multiplos ouvintes(listen)
void testeWithStreamControllerBroadCast () {

  final StreamController<int> controller = StreamController<int>.broadcast();

  int _data = 0;
  late StreamSubscription<int> listen;
  late StreamSubscription<int> listen2;

    Timer.periodic(Duration(seconds: 2), (timer) {// executar algo a cada 2 segundos
      
      if(_data == 11){
        listen.pause();
        print('---- ouvinte pausado ----');
        _data++;
      }else if(_data == 19){
        listen.resume();
        print('---- ouvinte em funcionamento ----');
        _data++;
      }else if(_data > 11 && _data < 19){
        print('---- none ----');
        _data++;
      }else if(_data <= 30){// imprimir apenas os intervalos 0 - 10 e 20 -30
        controller.add(_data++);
      }else{
        timer.cancel();
        listen.cancel();
        listen2.cancel();
        controller.sink.close();
        controller.close();
        print('---- Stream disposed ----');
      }

    });

  listen = controller.stream.listen(
    (data) {// onData
      print('$data');
    },
    onError: (_) => print('---- execute algo se ocorre algum erro'),
  );

  listen2 = controller.stream.listen(
    (data) {// onData
      print('from linten2: $data');
    },
    onError: (_) => print('---- execute algo se ocorre algum erro'),
  );

}

