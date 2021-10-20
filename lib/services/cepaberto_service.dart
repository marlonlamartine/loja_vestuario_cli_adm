import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loja_virtual_2_0/models/cepaberto_address.dart';

const token = '735a90a8a5c97a051806972441a16019';

class CepAbertoService {

  Future<CepAbertoAddress> getAddressFromCep(String cep) async{
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endPoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try{
      final response = await dio.get<Map<String, dynamic>>(endPoint);

      if(response.data.isEmpty){
        return Future.error('CEP inválido');
      }

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);

      return address;
    } on DioError catch (e){
      return Future.error('Erro ao buscar CEP');
    }
  }

}