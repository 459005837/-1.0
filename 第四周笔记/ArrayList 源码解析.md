简介：
	list集合和set集合顶层是Collection接口；而Collection接口又继承了Iterable接口（迭代器接口）；而正因为list和set有着有无索引的区别，所以Collection中定义了最基本的增删查改的方法，是没有索引的，接下来的list接口和set接口才开始区分索引这个概念；

源码中，还发现不单单只是只有接口这些，还有每一个接口对应的抽象类里为接口实现了一些子类共性的方法，但是在抽象类中所实现的方法其子类大多都有重写，所以可以直接看ArrayList的源码。

   ArrayList 实现 **RandomAccess** 接口的目的，起到一种标记作用，因为LinkedList和ArrayList底层实现分别是数组和链表，所以说两者在查询和做出增添删除元素的操作上有效率上的区别，因此当使用工具类查找时工具类内部会判断是否有 **RandomAccess** 标记，然后再实行不同的查找方式。
	参照链接：[https://www.cnblogs.com/javastack/p/12930217.html](https://www.cnblogs.com/javastack/p/12930217.html)

   ArrayList实现**Cloneable**接口和实现**Serializable**接口，一个是克隆，一个是序列化，如果不实现Cloneable接口，调用clone的时候会抛出异常，序列化接口是为了实现将集合序列化形式后通过流的方式进行存储。**Cloneable**接口，涉及到深、浅拷贝等知识。
	参照链接：[https://www.jianshu.com/p/643209062504](https://www.jianshu.com/p/643209062504)


```java

	/*
	带有一个整型参数的构造方法，如果大于0，就表示创建一个指定大小的数组
	如果等于0，就让其等于上面创建好的空的数组
	否则小于0表示异常数据
	*/
    public ArrayList(int initialCapacity) {
        if (initialCapacity > 0) {
            this.elementData = new Object[initialCapacity];
        } else if (initialCapacity == 0) {
            this.elementData = EMPTY_ELEMENTDATA;
        } else {
            throw new IllegalArgumentException("Illegal Capacity: "+
                                               initialCapacity);
        }
    }


	/*
	空参构造方法，这里的DEFAULTCAPACITY_EMPTY_ELEMENTDATA实际上和上面的EMPTY_ELEMENTDATA
	是类似的，只不过名字不一样而已，因为初始化的时候都是空的
	*/
    public ArrayList() {
        this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
    }


	/*
	带有一个集合的构造方法，意思是将此集合中的元素赋到新建的ArrayList集合中，
	因为ArrayList是基于数组实现的，所以这里先利用toArray方法获得参数集合的数组，
	然后赋给新建的数组；然后将长度赋给size如果不等于0，就判断数组类型是否属于Object类型，
	不是的话就做一次转换，如果长度为0的话，就还是像上面那样将空的数组赋给ArrayLis数组
	*/
    public ArrayList(Collection<? extends E> c) {
        elementData = c.toArray();
        if ((size = elementData.length) != 0) {
            // c.toArray might (incorrectly) not return Object[] (see 6260652)
            if (elementData.getClass() != Object[].class)
                elementData = Arrays.copyOf(elementData, size, Object[].class);
        } else {
            // replace with empty array.
            this.elementData = EMPTY_ELEMENTDATA;
        }
    }


	/*
	微调，就是将这个ArrayList的容量调整为实际的集合的大小，比如说现在数组的容量是10，
	但是我只存了两个位置，那就可以通过这个方法来最小化ArrayList实例的存储量
	*/
    public void trimToSize() {
        modCount++;
        if (size < elementData.length) {
            elementData = (size == 0)
              ? EMPTY_ELEMENTDATA
              : Arrays.copyOf(elementData, size);
        }
    }


	/*
	开放的API，意思可以根据传入的参数，然后进行一系列的是否合理判断，以及是否超出或者小于0等，
	然后进行数组的扩容。   先判断数组是否为空，如果为空就安排minExpand为默认容量 10 ，如果
	不为空，就安排为0； 然后进行两个参数的判断，大者作为参数传到另一个方法。
	*/
    public void ensureCapacity(int minCapacity) {
        int minExpand = (elementData != DEFAULTCAPACITY_EMPTY_ELEMENTDATA)
            // any size if not default element table
            ? 0
            // larger than default for default empty table. It's already
            // supposed to be at default size.
            : DEFAULT_CAPACITY;

        if (minCapacity > minExpand) {
            ensureExplicitCapacity(minCapacity);
        }
    }


	/*
	这里上下几个方法可以理解成上面那个方法是手动可控扩容，然后下面这两个方法，是内部处理增加数据
	时的扩容，这个方法主要是一个过滤，也就是传入数组和一个扩容数，在add的时候，会传来一个size+1
	（后面有），那这个时候如果传来的size+1比默认容量 10 小的话，那就取最大 10来扩容，返回一个
	扩容大小值
	*/
    private static int calculateCapacity(Object[] elementData, int minCapacity) {
        if (elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {
            return Math.max(DEFAULT_CAPACITY, minCapacity);
        }
        return minCapacity;
    }

	
	/*
	这个方法主要起到中介作用，主要是调用了上面那个方法获取合理的扩容量然后再调用下下面这个方法
	*/
    private void ensureCapacityInternal(int minCapacity) {
        ensureExplicitCapacity(calculateCapacity(elementData, minCapacity));
    }

	
	/*
	经过前三个方法的铺垫，主要还是来到这里，那这里首先要记录下结构性修改的次数，然后最后做一次
	判断grow扩容的值是否合理，然后跳转到grow进行数组的扩容；这里我有一个思考，就是什么时候才
	不需要扩容呢，就是当数组里的容量已经够了，比如刚开始add（后面）的时候，会传来一个size+1，那
	这个时候程序会赋一个 10，那当下次再来一个size+1的时候，因为此时的length已经为10，那下面这个
	if判断就会使false就不会去扩容了
	*/
    private void ensureExplicitCapacity(int minCapacity) {
        modCount++;
		
        // overflow-conscious code
        if (minCapacity - elementData.length > 0)
            grow(minCapacity);
    }

	/*
	前面设计到的是扩容大小的判断，接下来涉及到了最大值的判断了
	*/
    private static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;


	/*
	传过来一个扩容的值，进行扩容；首先拿到当前数组的长度oldCapacity ，然后对数组进行
	1.5的扩容，>>1 就表示取一半，获得newCapacity，然后比较一下，为什么要获得1.5再比较呢
	为什么不直接扩容minCapacity呢，可能是一种考虑吧，就像add size+1 它就给你扩容了 10 个
	然后如果1.5还是太少了，就把minCapacity赋给newCapacity，然后还要判断是否超出了最大MAX
	再经过下下面的hugeCapacity拿到合理值，最后进行数组的扩容，调用Arrays的CopyOf方法，
	其扩容原理就是创建一个新的变长了的数组，然后新地址指向旧地址
	*/
    private void grow(int minCapacity) {
        // overflow-conscious code
        int oldCapacity = elementData.length;
        int newCapacity = oldCapacity + (oldCapacity >> 1);
        if (newCapacity - minCapacity < 0)
            newCapacity = minCapacity;
        if (newCapacity - MAX_ARRAY_SIZE > 0)
            newCapacity = hugeCapacity(minCapacity);
        // minCapacity is usually close to size, so this is a win:
        elementData = Arrays.copyOf(elementData, newCapacity);
    }


	/*
	上面大与最大值的判断，因为上面的new..有两种情况，一种是1.5一种是minCapacity
	所以这里还要看看minCapacity是否小于0，然后如果大于MAX_ARRAY_SIZE的话旧直接
	用最大值来，若没有的话就用MAX_ARRAY_SIZE；
	ps ： MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8 （在另一个AbstractList源码
	里有注明）
	*/
    private static int hugeCapacity(int minCapacity) {
        if (minCapacity < 0) // overflow
            throw new OutOfMemoryError();
        return (minCapacity > MAX_ARRAY_SIZE) ?
            Integer.MAX_VALUE :
            MAX_ARRAY_SIZE;
    }


	/*
	获得数组的大小，这里刚开始看会有点疑惑，觉得为什么不用计算直接返回size，原因是
	在后面的add等方法启动时会涉及到size++等，所以直接返回
	*/
    public int size() {
        return size;
    }


	/*
	是否为空，size为0就为空
	*/
    public boolean isEmpty() {
        return size == 0;
    }


	/*
	判断是否包含某一个，就调用后面的indexof判断参数就行
	*/
    public boolean contains(Object o) {
        return indexOf(o) >= 0;
    }


	/*
	第一次出现时的索引，很简单，主要用for循环，来遍历，如果有就返回非 -1 ，注意这里比较还是用了两种
	==  和  equals
	*/
    public int indexOf(Object o) {
        if (o == null) {
            for (int i = 0; i < size; i++)
                if (elementData[i]==null)
                    return i;
        } else {
            for (int i = 0; i < size; i++)
                if (o.equals(elementData[i]))
                    return i;
        }
        return -1;
    }


	/*
	最后一次出现时的索引，就是从后往前遍历，方式跟上边一样，这个地方其实重写了AbstractList，
	那里用的时迭代器前后遍历，这里利用索引，因为数组索引比较快
	*/
    public int lastIndexOf(Object o) {
        if (o == null) {
            for (int i = size-1; i >= 0; i--)
                if (elementData[i]==null)
                    return i;
        } else {
            for (int i = size-1; i >= 0; i--)
                if (o.equals(elementData[i]))
                    return i;
        }
        return -1;
    }


	/*
	克隆，这里还涉及到一个深克隆和浅克隆的概念，后续补充，主要就是创建一个一样大小的数组
	然后赋给新开的ArrayList然后返回
	*/
    public Object clone() {
        try {
            ArrayList<?> v = (ArrayList<?>) super.clone();
            v.elementData = Arrays.copyOf(elementData, size);
            v.modCount = 0;
            return v;
        } catch (CloneNotSupportedException e) {
            // this shouldn't happen, since we are Cloneable
            throw new InternalError(e);
        }
    }



    public Object[] toArray() {
        return Arrays.copyOf(elementData, size);
    }



    public <T> T[] toArray(T[] a) {
        if (a.length < size)
            // Make a new array of a's runtime type, but my contents:
            return (T[]) Arrays.copyOf(elementData, size, a.getClass());
        System.arraycopy(elementData, 0, a, 0, size);
        if (a.length > size)
            a[size] = null;
        return a;
    }


	/*
	获取值，后面的方法都是通过这个地方来获取值的，即利用索引
	*/
    E elementData(int index) {
        return (E) elementData[index];
    }


	/*
	根据索引获取值，首先需要检查索引是否大于数组的size
	*/
    public E get(int index) {
        rangeCheck(index);

        return elementData(index);
    }


	/*
	替换指定索引的值，elemet为新的值，首先检查索引是否合理，然后拿到原来的值，
	再将新值赋给索引处，返回旧值
	*/
    public E set(int index, E element) {
        rangeCheck(index);

        E oldValue = elementData(index);
        elementData[index] = element;
        return oldValue;
    }


	/*
	添加元素，添加元素前会先通过ensureCapacityInternal方法，来判断数组容量是否合理，
	不合理就需要扩容，那扩容就需要重新创建数组，然后再执行复制操作
	*/
    public boolean add(E e) {
        ensureCapacityInternal(size + 1);  // Increments modCount!!
        elementData[size++] = e;
        return true;
    }


	/*
	指定索引处添加元素，首先需要判断索引是否合理，然后判断数组容量是否合理，
	然后执行复制操作，复制操作即System的copy，就是把索引位置处的数据全都向后移一位，
	然后索引处重新给赋新值，最后长度size++
	*/
    public void add(int index, E element) {
        rangeCheckForAdd(index);

        ensureCapacityInternal(size + 1);  // Increments modCount!!
        System.arraycopy(elementData, index, elementData, index + 1,
                         size - index);
        elementData[index] = element;
        size++;
    }


	/*
	移除指定索引下的元素，首先还是需要判断一下这个索引是否合理，有没有超出，然后修改
	modCount结构性修改次数，拿到即将被移除的元素，再计算后面还剩多少数据，就是size
	- (index + 1)然后调用System的方法，将后面的数全都赋值前一位，然后让最后一位
	--size为空即可（size为具体大小，length为实际容量）
	*/
    public E remove(int index) {
        rangeCheck(index);

        modCount++;
        E oldValue = elementData(index);

        int numMoved = size - index - 1;
        if (numMoved > 0)
            System.arraycopy(elementData, index+1, elementData, index,
                             numMoved);
        elementData[--size] = null; // clear to let GC do its work

        return oldValue;
    }
   

	/*
	移除某一个元素，就是利用索引遍历，然后得到那个元素所在的索引，然后调用下面的fastRemove
	其实就跟上面一样，只是没有返回值而已，然后这里返回返回布尔值
	*/
    public boolean remove(Object o) {
        if (o == null) {
            for (int index = 0; index < size; index++)
                if (elementData[index] == null) {
                    fastRemove(index);
                    return true;
                }
        } else {
            for (int index = 0; index < size; index++)
                if (o.equals(elementData[index])) {
                    fastRemove(index);
                    return true;
                }
        }
        return false;
    }


	/*
	专门用来移除某一个元素的方法，内部使用，无返回值，这里可能涉及到GC机制，后续
	再做补充
	*/
    private void fastRemove(int index) {
        modCount++;
        int numMoved = size - index - 1;
        if (numMoved > 0)
            System.arraycopy(elementData, index+1, elementData, index,
                             numMoved);
        elementData[--size] = null; // clear to let GC do its work
    }


	/*
	清空数组，就是遍历让每一个元素的地址都为null，然后让大小size为0即可
	*/
    public void clear() {
        modCount++;

        // clear to let GC do its work
        for (int i = 0; i < size; i++)
            elementData[i] = null;

        size = 0;
    }


	/*
	添加指定集合中的元素要此数组中，首先拿到要添加的数组的长度，然后进行数组容量的判断，
	不够则扩容，然后再执行System复制的操作，然后让size的大小修改为新的值，然后最后利用
	集合长度是否有效作为真假值返回
	*/
    public boolean addAll(Collection<? extends E> c) {
        Object[] a = c.toArray();
        int numNew = a.length;
        ensureCapacityInternal(size + numNew);  // Increments modCount
        System.arraycopy(a, 0, elementData, size, numNew);
        size += numNew;
        return numNew != 0;
    }


	/*
	指定索引开始添加指定集合中的元素，首先还是判断索引是否合理，然后获取新数组的长度，
	然后根据新的大小判断当前数组长度是否合理，否则扩充容量，然后如果a的长度大于0，就
	先将原先数组后面的那一部分开始先后移numMoved的大小，然后再将指定集合中的元素添加
	到那一部分去，最后改变size的大小
	*/
    public boolean addAll(int index, Collection<? extends E> c) {
        rangeCheckForAdd(index);

        Object[] a = c.toArray();
        int numNew = a.length;
        ensureCapacityInternal(size + numNew);  // Increments modCount

        int numMoved = size - index;
        if (numMoved > 0)
            System.arraycopy(elementData, index, elementData, index + numNew,
                             numMoved);

        System.arraycopy(a, 0, elementData, index, numNew);
        size += numNew;
        return numNew != 0;
    }


	/*
	移除指定索引之间的元素，首先结构性修改次数 +1，然后计算后面还剩多少，调用复制的方法
	将剩余的元素复制到以移除起点开始的索引位置处，复制长度为numMoved，然后将后面的都置为
	null，改变当前size的大小
	*/
    protected void removeRange(int fromIndex, int toIndex) {
        modCount++;
        int numMoved = size - toIndex;
        System.arraycopy(elementData, toIndex, elementData, fromIndex,
                         numMoved);

        // clear to let GC do its work
        int newSize = size - (toIndex-fromIndex);
        for (int i = newSize; i < size; i++) {
            elementData[i] = null;
        }
        size = newSize;
    }


	/*
	用到这个检查的有get(int index)、set(int index, E element)、remove(int index)
	这三个方法，然后一下两个方法的区别参见[https://www.zhihu.com/question/56689381](https://www.zhihu.com/question/56689381)
	*/
    private void rangeCheck(int index) {
        if (index >= size)
            throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
    }

    private void rangeCheckForAdd(int index) {
        if (index > size || index < 0)
            throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
    }
	
	/*
	定义抛出异常的模板
	*/
    private String outOfBoundsMsg(int index) {
        return "Index: "+index+", Size: "+size;
    }


	/*
	移除指定集合中的元素，首先需要判断不为null
	*/
    public boolean removeAll(Collection<?> c) {
        Objects.requireNonNull(c);
        return batchRemove(c, false);
    }


	/*
	保留指定集合中的元素，首先需要判断不为null
	*/
    public boolean retainAll(Collection<?> c) {
        Objects.requireNonNull(c);
        return batchRemove(c, true);
    }


	/*
	这个方法是用来处理移除一个集合中的元素，和保留一个集合中的元素的，也就是上面所调用的方法；
	传入参数是一个集合和一个布尔类型，表示删除还是保留，首先获得当前集合，然后定义两个参数r w，
	首先经过一个for循环遍历容器，调用参数中的集合的contains方法判断当前集合中的元素是否有在内，
	有表示true，而removeAll来的是false，则不执行if语句下面的方法，当没有时即false，执行下面的方法，
	下面的方法即以w为参数，进行赋值，可以举个例子，当第一个元素包含时，不执行w，w为0，当第二个元素不包含
	时，将elementData【1】赋给w=0的索引；同理，retainAll正好相反；

	当contains发生异常无法完全遍历的时候就需要到下面的finally中的第一个if语句，意思是将后面
	没有遍历完的都赋给刚刚的w中的位置后面，然后这个时候更新w，这时计算出来的w为新的数组的大小，
	然后如果集合中有元素要移除，则后面的元素前进后，再最后面剩下的位数应该置为null，所以最后
	加一个判断来遍历置为null
	*/
    private boolean batchRemove(Collection<?> c, boolean complement) {
        final Object[] elementData = this.elementData;
        int r = 0, w = 0;
        boolean modified = false;
        try {
            for (; r < size; r++)
            	//可以研究一下为什么这里  可能  会抛异常
                if (c.contains(elementData[r]) == complement)
                    elementData[w++] = elementData[r];
        } finally {
            // Preserve behavioral compatibility with AbstractCollection,
            // even if c.contains() throws.
            if (r != size) {
                System.arraycopy(elementData, r,
                                 elementData, w,
                                 size - r);
                //此时的大小                 
                w += size - r;
            }
            if (w != size) {
                // clear to let GC do its work
                for (int i = w; i < size; i++)
                    elementData[i] = null;
                //增加结构性修改次数
                modCount += size - w;
                size = w;
                //修改状态为true
                modified = true;
            }
        }
        return modified;
    }


	//writeObject和readObject暂时不明白用法和意义，大概是实现已有元素序列化
    private void writeObject(java.io.ObjectOutputStream s)
        throws java.io.IOException{
        // Write out element count, and any hidden stuff
        int expectedModCount = modCount;
        s.defaultWriteObject();

        // Write out size as capacity for behavioural compatibility with clone()
        s.writeInt(size);

        // Write out all elements in the proper order.
        for (int i=0; i<size; i++) {
            s.writeObject(elementData[i]);
        }

        if (modCount != expectedModCount) {
            throw new ConcurrentModificationException();
        }
    }



    private void readObject(java.io.ObjectInputStream s)
        throws java.io.IOException, ClassNotFoundException {
        elementData = EMPTY_ELEMENTDATA;

        // Read in size, and any hidden stuff
        s.defaultReadObject();

        // Read in capacity
        s.readInt(); // ignored

        if (size > 0) {
            // be like clone(), allocate array based upon size not capacity
            int capacity = calculateCapacity(elementData, size);
            SharedSecrets.getJavaOISAccess().checkArray(s, Object[].class, capacity);
            ensureCapacityInternal(size);

            Object[] a = elementData;
            // Read in all elements in the proper order.
            for (int i=0; i<size; i++) {
                a[i] = s.readObject();
            }
        }
    }


	/*
	获得带有索引的ListIterator的迭代器，
	*/
    public ListIterator<E> listIterator(int index) {
        if (index < 0 || index > size)
            throw new IndexOutOfBoundsException("Index: "+index);
        return new ListItr(index);
    }


	/*
	获得初始索引为0的ListIterator的迭代器
	*/
    public ListIterator<E> listIterator() {
        return new ListItr(0);
    }


	/*
	获得原生的迭代器
	*/
    public Iterator<E> iterator() {
        return new Itr();
    }


	/*
	定义三个参数，cursor用来获取即将拿出来的数据的索引，lasRet用来记录下当前拿出来的数据的索引，
	便于后面进行remove操作，expetModCount表示预期的修改次数，当迭代的时候发生了一些结构性的修改的
	时候，modCount的值就会发生改变，这个时候调用 checkForComodification方法时就会抛出异常
	*/
    private class Itr implements Iterator<E> {
        int cursor;       // index of next element to return
        int lastRet = -1; // index of last element returned; -1 if no such
        int expectedModCount = modCount;

        Itr() {}
		/*
		上面说到了cursor表示要拿的数据的索引，比如现在有4个数据，当拿到索引为3的数据的时候，
		根据迭代器的原理，即到数据后已经next了，下面的方法中也有突出，那此时cursor的数就变成4
		则返回false，没有下一个值了
        */
        public boolean hasNext() {
            return cursor != size;
        }
		/*
		首先检查是否发生同步修改错误，然后将要拿的数据的索引赋给i，判断i的大小和size以及length的比较，
		然后通过刚刚赋值的i拿到值顺便赋给lastRet，同时把cursor+1
		*/
        @SuppressWarnings("unchecked")
        public E next() {
            checkForComodification();
            int i = cursor;
            if (i >= size)
                throw new NoSuchElementException();
            Object[] elementData = ArrayList.this.elementData;
            if (i >= elementData.length)
                throw new ConcurrentModificationException();
            cursor = i + 1;
            return (E) elementData[lastRet = i];
        }
		
		/*
		首先判断lastRet是否小于0，因为如果刚刚做了一个remove这个动作的话是会把lastRet置为-1的， 
		然后再调用remove这个方法移除记录的索引的位置，然后cursor要后退一个索引，因为remove的时候
		后面的数会前进一个索引，
		*/
        public void remove() {
            if (lastRet < 0)
                throw new IllegalStateException();
            checkForComodification();

            try {
                ArrayList.this.remove(lastRet);
                cursor = lastRet;
                lastRet = -1;
                expectedModCount = modCount;
            } catch (IndexOutOfBoundsException ex) {
                throw new ConcurrentModificationException();
            }
        }
		
		/*
		jdk1.8的新特性，也就是可以通过这个方法遍历集合，后续再补充详细的做法
		*/
        @Override
        @SuppressWarnings("unchecked")
        public void forEachRemaining(Consumer<? super E> consumer) {
            Objects.requireNonNull(consumer);
            final int size = ArrayList.this.size;
            int i = cursor;
            if (i >= size) {
                return;
            }
            final Object[] elementData = ArrayList.this.elementData;
            if (i >= elementData.length) {
                throw new ConcurrentModificationException();
            }
            while (i != size && modCount == expectedModCount) {
                consumer.accept((E) elementData[i++]);
            }
            // update once at end of iteration to reduce heap write traffic
            cursor = i;
            lastRet = i - 1;
            checkForComodification();
        }
		//再当前迭代器修改东西的时候检查是否有发生结构性修改的事件，如果有就爆出异常
        final void checkForComodification() {
            if (modCount != expectedModCount)
                throw new ConcurrentModificationException();
        }
    }


	/*
	list集合特有的迭代器，其实这里在AbstractList中已经有实现过了，只不过ArrayList
	中索引方式和LinkedList不同，所以重新实现一遍
	*/
    private class ListItr extends Itr implements ListIterator<E> {
    	/*
    	首先是一个构造方法，因为listIterator主要是来逆向遍历，也就是从后面遍历，但是也不一定要从最后面，可以从中间开始，
    	如果是从最后面开始的话，比如上面的lastIndex方法,查找最后一次出现指定数据的索引，传过来的就是size
    	*/
        ListItr(int index) {
            super();
            cursor = index;
        }
		//判断是否有前一位数据，因为cursor是要来表示索引下标的，所以如果当传过来的index是0的话，就没有前一位了
        public boolean hasPrevious() {
            return cursor != 0;
        }
		/*
		获取当前拿到的数据的索引，这个方法在上面的lastIndex中有用到，其实名字是nextIndex但是拿到的索引还是刚刚获得的数据的，因为迭代器的	
		原理就是每拿到一个数据位置就移动，所以向前遍历自然就是拿到下一位的索引
        */
        public int nextIndex() {
            return cursor;
        }
		//同理， 拿到前一位的索引，就是当前索引 - 1 ，ListIterator中的cursor和Iterator中的就表示了不同的位置了
        public int previousIndex() {
            return cursor - 1;
        }
		//这里拿到值得方式其实跟上面得迭代器的思路是一样的只不过这里是往前拿值，所以需要 -1
        @SuppressWarnings("unchecked")
        public E previous() {
            checkForComodification();
            int i = cursor - 1;
            if (i < 0)
                throw new NoSuchElementException();
            Object[] elementData = ArrayList.this.elementData;
            if (i >= elementData.length)
                throw new ConcurrentModificationException();
            cursor = i;
            return (E) elementData[lastRet = i];
        }
		/*
		将当前数据替换掉，首先还是判断lastRet是否小于0，因为如果在这之前执行了remove操作的话，
		也就是把当前数据移除，那此时lastRet会回到-1，也就是不能进行替代操作了；再调用set方法
        */
        public void set(E e) {
            if (lastRet < 0)
                throw new IllegalStateException();
            checkForComodification();

            try {
                ArrayList.this.set(lastRet, e);
            } catch (IndexOutOfBoundsException ex) {
                throw new ConcurrentModificationException();
            }
        }
		/*
		添加元素，首先拿到数据，然后要往这个数据和前一个数据中间添加元素，
		其实也就是将即将要添加的元素放在当前数据的索引下，然后当前数据包括
		后面的数据全部向后移一位，那根据上面next中cursor表示的意义，
		即指向当前拿到的数据，那cursor理应向后移一位，也就是下一次遍历将拿到刚
		刚插入的数据，lastRet回到-1，下一次拿数据再次赋予 i 值；
		这里调用add 方法，利用索引添加元素  
        */
        public void add(E e) {
            checkForComodification();

            try {
                int i = cursor;
                ArrayList.this.add(i, e);
                cursor = i + 1;
                lastRet = -1;
                expectedModCount = modCount;
            } catch (IndexOutOfBoundsException ex) {
                throw new ConcurrentModificationException();
            }
        }
    }


	/*
	sublist，获得当前集合的子列表,也就是截取中间一部分集合，提供从哪开始，到哪结束的索引
	*/
    public List<E> subList(int fromIndex, int toIndex) {
        subListRangeCheck(fromIndex, toIndex, size);
        return new SubList(this, 0, fromIndex, toIndex);
    }
	

	/*
	获取子列表的时候需要先判断索引是否合理
	*/
    static void subListRangeCheck(int fromIndex, int toIndex, int size) {
        if (fromIndex < 0)
            throw new IndexOutOfBoundsException("fromIndex = " + fromIndex);
        if (toIndex > size)
            throw new IndexOutOfBoundsException("toIndex = " + toIndex);
        if (fromIndex > toIndex)
            throw new IllegalArgumentException("fromIndex(" + fromIndex +
                                               ") > toIndex(" + toIndex + ")");
    }


	/*
	这是获得子列表的内部类，
	首先解读几个参数，第一个是parent，也就是原先的那个集合，也就是顶级的集合，后面所有的
	子列表操作都是基于原先集合来操作的；parentOffset表示相对于父集合开始的索引，因为构造
	方法中，赋给的值是fromIndex；offset表示相对于原始集合的索引，这两个offset的理解可能
	比较抽象，就好像层层递归一样，所以我这里区别出了原始集合和父集合两个概念
	*/
    private class SubList extends AbstractList<E> implements RandomAccess {
        private final AbstractList<E> parent;
        private final int parentOffset;
        private final int offset;
        int size;

		//根据构造方法的赋值，再加上上面这段话的理解，j
        SubList(AbstractList<E> parent,
                int offset, int fromIndex, int toIndex) {
            this.parent = parent;
            this.parentOffset = fromIndex;
            this.offset = offset + fromIndex;
            this.size = toIndex - fromIndex;
            this.modCount = ArrayList.this.modCount;
        }

        public E set(int index, E e) {
            rangeCheck(index);
            checkForComodification();
            E oldValue = ArrayList.this.elementData(offset + index);
            ArrayList.this.elementData[offset + index] = e;
            return oldValue;
        }

        public E get(int index) {
            rangeCheck(index);
            checkForComodification();
            return ArrayList.this.elementData(offset + index);
        }

        public int size() {
            checkForComodification();
            return this.size;
        }

        public void add(int index, E e) {
            rangeCheckForAdd(index);
            checkForComodification();
            parent.add(parentOffset + index, e);
            this.modCount = parent.modCount;
            this.size++;
        }

        public E remove(int index) {
            rangeCheck(index);
            checkForComodification();
            E result = parent.remove(parentOffset + index);
            this.modCount = parent.modCount;
            this.size--;
            return result;
        }

        protected void removeRange(int fromIndex, int toIndex) {
            checkForComodification();
            parent.removeRange(parentOffset + fromIndex,
                               parentOffset + toIndex);
            this.modCount = parent.modCount;
            this.size -= toIndex - fromIndex;
        }

        public boolean addAll(Collection<? extends E> c) {
            return addAll(this.size, c);
        }

        public boolean addAll(int index, Collection<? extends E> c) {
            rangeCheckForAdd(index);
            int cSize = c.size();
            if (cSize==0)
                return false;

            checkForComodification();
            parent.addAll(parentOffset + index, c);
            this.modCount = parent.modCount;
            this.size += cSize;
            return true;
        }

        public Iterator<E> iterator() {
            return listIterator();
        }

        public ListIterator<E> listIterator(final int index) {
            checkForComodification();
            rangeCheckForAdd(index);
            final int offset = this.offset;

            return new ListIterator<E>() {
                int cursor = index;
                int lastRet = -1;
                int expectedModCount = ArrayList.this.modCount;

                public boolean hasNext() {
                    return cursor != SubList.this.size;
                }

                @SuppressWarnings("unchecked")
                public E next() {
                    checkForComodification();
                    int i = cursor;
                    if (i >= SubList.this.size)
                        throw new NoSuchElementException();
                    Object[] elementData = ArrayList.this.elementData;
                    if (offset + i >= elementData.length)
                        throw new ConcurrentModificationException();
                    cursor = i + 1;
                    return (E) elementData[offset + (lastRet = i)];
                }

                public boolean hasPrevious() {
                    return cursor != 0;
                }

                @SuppressWarnings("unchecked")
                public E previous() {
                    checkForComodification();
                    int i = cursor - 1;
                    if (i < 0)
                        throw new NoSuchElementException();
                    Object[] elementData = ArrayList.this.elementData;
                    if (offset + i >= elementData.length)
                        throw new ConcurrentModificationException();
                    cursor = i;
                    return (E) elementData[offset + (lastRet = i)];
                }

                @SuppressWarnings("unchecked")
                public void forEachRemaining(Consumer<? super E> consumer) {
                    Objects.requireNonNull(consumer);
                    final int size = SubList.this.size;
                    int i = cursor;
                    if (i >= size) {
                        return;
                    }
                    final Object[] elementData = ArrayList.this.elementData;
                    if (offset + i >= elementData.length) {
                        throw new ConcurrentModificationException();
                    }
                    while (i != size && modCount == expectedModCount) {
                        consumer.accept((E) elementData[offset + (i++)]);
                    }
                    // update once at end of iteration to reduce heap write traffic
                    lastRet = cursor = i;
                    checkForComodification();
                }

                public int nextIndex() {
                    return cursor;
                }

                public int previousIndex() {
                    return cursor - 1;
                }

                public void remove() {
                    if (lastRet < 0)
                        throw new IllegalStateException();
                    checkForComodification();

                    try {
                        SubList.this.remove(lastRet);
                        cursor = lastRet;
                        lastRet = -1;
                        expectedModCount = ArrayList.this.modCount;
                    } catch (IndexOutOfBoundsException ex) {
                        throw new ConcurrentModificationException();
                    }
                }

                public void set(E e) {
                    if (lastRet < 0)
                        throw new IllegalStateException();
                    checkForComodification();

                    try {
                        ArrayList.this.set(offset + lastRet, e);
                    } catch (IndexOutOfBoundsException ex) {
                        throw new ConcurrentModificationException();
                    }
                }

                public void add(E e) {
                    checkForComodification();

                    try {
                        int i = cursor;
                        SubList.this.add(i, e);
                        cursor = i + 1;
                        lastRet = -1;
                        expectedModCount = ArrayList.this.modCount;
                    } catch (IndexOutOfBoundsException ex) {
                        throw new ConcurrentModificationException();
                    }
                }

                final void checkForComodification() {
                    if (expectedModCount != ArrayList.this.modCount)
                        throw new ConcurrentModificationException();
                }
            };
        }

        public List<E> subList(int fromIndex, int toIndex) {
            subListRangeCheck(fromIndex, toIndex, size);
            return new SubList(this, offset, fromIndex, toIndex);
        }

        private void rangeCheck(int index) {
            if (index < 0 || index >= this.size)
                throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
        }

        private void rangeCheckForAdd(int index) {
            if (index < 0 || index > this.size)
                throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
        }

        private String outOfBoundsMsg(int index) {
            return "Index: "+index+", Size: "+this.size;
        }

        private void checkForComodification() {
            if (ArrayList.this.modCount != this.modCount)
                throw new ConcurrentModificationException();
        }

        public Spliterator<E> spliterator() {
            checkForComodification();
            return new ArrayListSpliterator<E>(ArrayList.this, offset,
                                               offset + this.size, this.modCount);
        }
    }
```

