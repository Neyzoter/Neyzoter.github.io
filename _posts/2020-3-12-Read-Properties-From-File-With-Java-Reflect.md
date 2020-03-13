---
layout: post
title: 利用Java反射机制实现从外部文件配置一个对象
categories: Java
description: 利用Java反射机制实现配置一个对象
keywords: Java, 反射
---



> 通过Java反射机制，实现从外部文件读取JSON属性，并配置对象的变量。

# 1. Java反射及应用

反射可以在运行时根据指定的类名、变量名、方法名获得对应的信息，可以实现较高可复用性。

比如我现在有一个需求：我在Java中实现归一化操作，此时需要知道特征的最大最小值。而最大最小值是在用Python训练模型时确定的，我需要在文本中将最大最小值存储下来，Java可以随时读取。为了提高系统的可复用性，文本是properties文件，以json的格式来保存数据，Java读取数据后以Java反射的方式给对象赋值，比如

```properties
max-value={val1:0.23,val2:1.34}
```

其中`max-value`指示配置最大值，`{val1:0.23,val2:1.34}`以json的方式来指定保存最大数据对象的变量。下面是一个保存特征的类，

```java
@Setter
@Getter
public class RuntimeData {
	private Double val1;
    private Float val2;
	public void valFromStr (String val, String valName){
		// 实现通过valName指定变量名，来给对应的变量赋值，
        // 具体为val，val需要转化为对应的类型
    }
}
```

那么，Java在读取properties文件中的`max-value`后，解析出变量名和其对应的数值（都是字符串格式），通过函数`valFromStr`实现给对象赋值。

# 2. 具体实现

具体实现主要是properties文件的读取、解析和`RuntimeData`的`valFromStr`方法。

下面是[properties管理类](https://github.com/Neyzoter/aiot/blob/master/common/src/main/java/cn/neyzoter/aiot/common/util/PropertiesUtil.java)，`getPropertiesMap`函数实现从properties文件中解析出JSON格式的数据，并以Map保存并返回。

```java
/**
 * properties Util
 * @author neyzoter song
 * @date 2019-12-11
 */
public class PropertiesUtil implements Serializable {
    private static final long serialVersionUID = -3031705469789764720L;
    private static final int MAX_PROPERTIES_MAP_CAP = 100;
    private static final String PROPERTIES_SEPERATOR = ",";
    private static final String KEY_VAL_SEPERATOR = ":";
    /**
     * properties
     */
    private Properties props=null;

    /**
     * file path
     */
    private String path;

    /**
     * load properties file
     */
    public PropertiesUtil(String path){
            this.updateProps(path);
    }

    /**
     * read property
     * @param key key
     * @return value
     */
    public String readValue(String key) {
        return  props.getProperty(key);
    }

    /**
     * 更新属性
     * @param path properties file
     */
    public void updateProps (String path) {
        this.path = path;
        this.updateProps();

    }
    /**
     * 获取属性
     * @return
     */
    public void updateProps (){
        try{
            BufferedReader bufferedReader = new BufferedReader(new FileReader(this.path));
            props = new Properties();
            props.load(bufferedReader);
        }catch (Exception e) {
            System.err.println(e);
        }
    }
    /**
     * 获取props
     * @return
     */
    public Properties getProps () {
        return props;
    }

    /**
     * trans json format properties to map
     * @param properties json format properties <br/> such as {val1:0.12,val2:2.2}
     * @return properties Map
     */
    public Map<String, String > getPropertiesMap (String properties) {
        Map<String, String> map = new HashMap<>(MAX_PROPERTIES_MAP_CAP);
        properties = properties.trim();
        // rm "{" and "}" and " "
        properties = properties.replaceAll("[\\{|\\}| ]","");
        // split
        String[] propertisArray = properties.split(PROPERTIES_SEPERATOR);
        for (String kv : propertisArray) {
            String[] kvArray = kv.split(KEY_VAL_SEPERATOR,2);
            map.put(kvArray[0],kvArray[1]);
        }
        return map;
    }

}
```

下面是[`RuntimeData`的简单实现](https://github.com/Neyzoter/aiot/blob/master/dal/src/main/java/cn/neyzoter/aiot/dal/domain/vehicle/RuntimeData.java)，重点是`valFromStr`函数，

```java
@Setter
@Getter
public class RuntimeData {
	private Double val1;
    private Float val2;
	public void valFromStr (String val, String valName){
        // 获取变量valName（valName可以是"val1"或者"val2"）的Field
        Field field = this.getClass().getDeclaredField(valName);
        // 查看field是否可到达
        boolean isAccessible = field.isAccessible();
        try {
            // 设置field为可到达
            field.setAccessible(true);
            // 将String类型转化为对应类型
            // field.getType()表示获取变量的类型，比如本类中val1是Double，val2是Float
            // isAssignableFrom表示判断是否是某一个类型
            if (field.getType().isAssignableFrom(Double.class)) {
                field.set(this, Double.parseDouble(val));
            } else if (field.getType().isAssignableFrom(Float.class)) {
                field.set(this, Float.parseFloat(val));
            } else if (field.getType().isAssignableFrom(Integer.class)) {
                field.set(this, Integer.parseInt(val));
            } else if (field.getType().isAssignableFrom(Long.class)) {
                field.set(this, Long.parseLong(val));
            } else if (field.getType().isAssignableFrom(String.class)) {
                field.set(this, val);
            }
        } finally {
            // 将该field设置为原来的状态
            field.setAccessible(isAccessible);
        }
    }
}
```

具体过程包括properties文件的读取、解析，返回Map后，使用Map遍历各个变量的名称和数值（都是String类型），通过`valFromStr`函数赋值。

**需要注意的是，Java反射效率并不高，所以尽可能在初始化时就确定配置值，不要反复更新。否则，会严重影响系统性能。**