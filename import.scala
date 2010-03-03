// import scala.xml._
// import scala.xml.parsing.XhtmlParser
import scala.io.Source
import scala.util.matching.Regex
// import _root_.com.yuroyoro.interactivehelp.Help._

object FileOut{
  import java.io.{Writer, OutputStreamWriter, FileOutputStream }

  def os(fileName:String):Writer =
    new OutputStreamWriter( new FileOutputStream( fileName ), "UTF-8")

  def apply( fileName:String, content:String ) = {
    val o = os( fileName )
    o.write( content )
    o.flush
    o.close
  }
  def apply( fileName:String, content:Seq[String] ) = {
    val o = os( fileName )
    content.foreach { c => o.write( c + "\n" ) }
    o.flush
    o.close
  }
}

class MapOrElseOption[A]( o:Option[A] ){

  def mapOrElse[B]( default : => B)( f:(A) => B ) = o match {
    case None => default
    case Some(x) => f(x)
  }
}

implicit def option2MapOrElseOption[A]( o:Option[A] ) = new MapOrElseOption( o )

