import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              //top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaInitial) {
                    return MessageDisplay(
                      message: "Start searching!",
                    );
                  } else if (state is NumberTriviaLoading) {
                    return LoadingWidget();
                  } else if (state is NumberTriviaLoaded) {
                    return NumberTriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is NumberTriviaError) {
                    return MessageDisplay(message: state.message);
                  }
                },
              ),
              SizedBox(height: 20),
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
