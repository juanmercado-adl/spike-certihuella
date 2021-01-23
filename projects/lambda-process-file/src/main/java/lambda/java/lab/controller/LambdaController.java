package lambda.java.lab.controller;

import com.amazonaws.services.s3.event.S3EventNotification;
import lambda.java.lab.config.AwsSdkConfig;
import lambda.java.lab.config.ComponentsConfig;
import lambda.java.lab.config.LambdaConfig;
import lambda.java.lab.model.LambdaModel;
import lambda.java.lab.service.ILambdaService;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.S3Event;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.google.gson.Gson;
import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.Module;

public class LambdaController implements RequestHandler<S3Event, String> {

  private static final Logger LOGGER = LoggerFactory.getLogger(LambdaController.class);
  private Injector injector;
  private Gson gsonBuilder;
  private ILambdaService service;
  private LambdaModel lambdaModel;


  @Override
  public String handleRequest(S3Event s3Event, Context context) {
    LOGGER.info("Start consumer LambdaController");
    bootInjector(new LambdaConfig(), new ComponentsConfig(), new AwsSdkConfig());
    LOGGER.info("EVENT: " + this.getGsonBuilder().toJson(s3Event));
    S3EventNotification.S3EventNotificationRecord record = s3Event.getRecords().get(0);
    String urlFile = record.getS3().getObject().getKey();
    this.service = injectLambdaService();
    this.service.save(
        this.getGsonBuilder().fromJson(this.getGsonBuilder().toJson(this.getLambdaModel(urlFile)), LambdaModel.class));
    LOGGER.info("End consumer LambdaController");
    return null;
  }

  private ILambdaService injectLambdaService() {
    return this.service == null ? injector.getInstance(ILambdaService.class) : this.service;
  }

  private Gson getGsonBuilder() {
    return gsonBuilder == null ? injector.getInstance(Gson.class) : gsonBuilder;
  }

  private LambdaModel getLambdaModel(String lambdaName) {
      if(lambdaModel == null){
          lambdaModel = new LambdaModel();
          lambdaModel.setLambdaName(lambdaName);
          return lambdaModel;
      }
      return lambdaModel;

  }

  private void bootInjector(final Module... modules) {
    if (injector == null) {
      injector = Guice.createInjector(modules);
    }
  }
}
