import 'dart:convert';

LimitApi limitApiFromJson(String str) => LimitApi.fromJson(json.decode(str));

String limitApiToJson(LimitApi data) => json.encode(data.toJson());

class LimitApi {
    Error error;

    LimitApi({
        this.error,
    });

    factory LimitApi.fromJson(Map<String, dynamic> json) => LimitApi(
        error: Error.fromJson(json["error"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error.toJson(),
    };
}

class Error {
    Error();

    factory Error.fromJson(Map<String, dynamic> json) => Error(
    );

    Map<String, dynamic> toJson() => {
    };
}