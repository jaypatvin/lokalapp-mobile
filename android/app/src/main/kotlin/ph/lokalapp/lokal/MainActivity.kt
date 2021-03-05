package ph.lokalapp.lokal

import android.os.Bundle
import com.fasterxml.jackson.databind.ObjectMapper

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant
import io.getstream.client.Client
import io.getstream.cloud.CloudClient
import io.getstream.core.models.Activity
import java.util.*
import io.getstream.core.options.Limit
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val CHANNEL = "io.getstream/backend"
    private val API_KEY = "9x4ysafkqkmz"
    private val token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyZXNvdXJjZSI6ImFuYWx5dGljcyIsImFjdGlvbiI6IioiLCJ1c2VyX2lkIjoiKiJ9.84xdCngA3KdA8VxTsHb5x2D4_f3sm3q7hbPrxa2M2MQ"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "postMessage") {
                postMessage(
                        call.argument<String>("user")!!,
                        call.argument<String>("token")!!,
                        call.argument<String>("message")!!
                )
                result.success(true)
            }else if(call.method == "postLikes"){
                postLikes(
                        call.argument<String>("user")!!,
                        call.argument<String>("token")!!,
                        call.argument<String>("likes")!!
                )
                result.success(true)
            } else if (call.method == "getActivities") {
                val activities = getActivities(
                        call.argument<String>("user")!!,
                        call.argument<String>("token")!!
                )
                result.success(ObjectMapper().writeValueAsString(activities))
            } else if (call.method == "getTimeline") {
                val activities = getTimeline(
                        call.argument<String>("user")!!,
                        call.argument<String>("token")!!
                )
                result.success(ObjectMapper().writeValueAsString(activities))
            } else if (call.method == "follow") {
                follow(
                        call.argument<String>("user")!!,
                        call.argument<String>("token")!!,
                        call.argument<String>("userToFollow")!!
                )
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }
    private fun postMessage(user: String, token: String, message: String) {
        val client = CloudClient.builder(API_KEY, token, user).build()
        val feed = client.flatFeed("community_QHdK73bGFQRmgmPr3enN")
        feed.addActivity(
                Activity
                        .builder()
                        .actor("SU:${user}")
                        .verb("post")
                        .`object`(UUID.randomUUID().toString())
                        .extraField("message", message)
                        .build()
        ).join()
    }
    private fun postLikes(user: String, token: String, likes: String) {
        val client = CloudClient.builder(API_KEY, token, user).build()
        val feed = client.flatFeed("community_QHdK73bGFQRmgmPr3enN")
        feed.addActivity(
                Activity
                        .builder()
                        .actor("SU:${user}")
                        .verb("post")
                        .extraField("likes", likes)
                        .build()
        ).join()
    }
    private fun getActivities(user: String, token: String): List<Activity> {

        val client = CloudClient.builder(API_KEY, token, user).build()
        return client.flatFeed("community_QHdK73bGFQRmgmPr3enN").getActivities(Limit(25)).join()
    }
    private fun getTimeline(user: String, token: String): List<Activity> {

        val client = CloudClient.builder(API_KEY, token, user).build()
        return client.flatFeed("community_QHdK73bGFQRmgmPr3enN").getActivities(Limit(25)).join()
    }
    private fun follow(user: String, token: String, userToFollow: String): Boolean {
        val client = CloudClient.builder(API_KEY, token, user).build()
        client.flatFeed("community_QHdK73bGFQRmgmPr3enN").follow(client.flatFeed("user", userToFollow)).join()
        return true
    }
}