package ph.lokalapp.lokal
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant
import io.getstream.client.Client
import io.getstream.cloud.CloudClient
import io.getstream.core.models.Activity
import java.util.*
import io.getstream.core.options.Limit
import org.json.JSONObject
class MainActivity : FlutterActivity() {
     private val CHANNEL = "ph.lokalapp.lokal"
private val API_KEY = "9x4ysafkqkmz"
        override fun onCreate(savedInstanceState: Bundle?) {

            super.onCreate(savedInstanceState)
            GeneratedPluginRegistrant.registerWith(this)
                GeneratedPluginRegistrant.registerWith(flutterEngine);

                MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
                    if (call.method == "postMessage") {
                        postMessage(
                                call.argument<String>("user")!!,
                                call.argument<String>("token")!!,
                                call.argument<String>("message")!!
                        )
                        result.success(true)
//            } else if (call.method == "getActivities") {
//                val activities = getActivities(
//                        call.argument<String>("user")!!,
//                        call.argument<String>("token")!!
//                )
//                result.success(ObjectMapper().writeValueAsString(activities))
//            } else if (call.method == "getTimeline") {
//                val activities = getTimeline(
//                        call.argument<String>("user")!!,
//                        call.argument<String>("token")!!
//                )
//                result.success(ObjectMapper().writeValueAsString(activities))
//            } else if (call.method == "follow") {
//                follow(
//                        call.argument<String>("user")!!,
//                        call.argument<String>("token")!!,
//                        call.argument<String>("userToFollow")!!
//                )
//                result.success(true)
                    } else {
                        result.notImplemented()
                    }

                }
            }
        }

        private fun postMessage(user: String, token: String, message: String) {
            val client = CloudClient.builder(API_KEY, token, user).build()

            val feed = client.flatFeed("feeds")
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

    }



