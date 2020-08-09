
**AbstractList 源码解析**

```java

	/*
	前面AbstractCollection中的add方法的实现，其实这里是调用了另一个参数不一样的add 方法，size大小和添加的元素 e
	*/
    public boolean add(E e) {
        add(size(), e);
        return true;
    }
	
	/*
	根据索引获取元素的方法，抽象方法，留给ArrayList实现
	*/
    abstract public E get(int index);
	
	/*
	根据索引替换元素，未实现，返回值是被替换元素的值
	*/
    public E set(int index, E element) {
        throw new UnsupportedOperationException();
    }

	/*
	根据索引添加元素，未实现
	*/
    public void add(int index, E element) {
        throw new UnsupportedOperationException();
    }

	/*
	根据索引移除元素。未实现，返回值是被移除的元素的值
	*/
    public E remove(int index) {
        throw new UnsupportedOperationException();
    }

	/*
	根据指定的类查询其 第一次出现时 所在的索引，这里创建的迭代器是list集合特有的迭代器，其功能和Iterator迭代器有所区别，后面补充，
	查询方式，还是利用迭代器，以及它的方法，获取其所在的索引，未找到返回-1，后面还是用了 == 和equals来判断
	*/
    public int indexOf(Object o) {
        ListIterator<E> it = listIterator();
        if (o==null) {
            while (it.hasNext())
                if (it.next()==null)
                    return it.previousIndex();
        } else {
            while (it.hasNext())
                if (o.equals(it.next()))
                    return it.previousIndex();
        }
        return -1;
    }

	/*
	根据指定的类查询其 最后一次出现时 所在的索引，这里用到了ListIterator迭代器的另一个方法，表示从集合尾开始向头查询，也就是说ListIterator		   			
	这个迭代器可以双向遍历，理解方式跟上面正向遍历一样
	*/
    public int lastIndexOf(Object o) {
        ListIterator<E> it = listIterator(size());
        if (o==null) {
            while (it.hasPrevious())
                if (it.previous()==null)
                    return it.nextIndex();
        } else {
            while (it.hasPrevious())
                if (o.equals(it.previous()))
                    return it.nextIndex();
        }
        return -1;
    }

	/*
	清空集合内容，这里调用了removeRange方法，下面有
	*/
    public void clear() {
        removeRange(0, size());
    }

	/*
	往指定索引处开始添加 集合 c 中的元素，首先需要判断此索引是否合理，即是否小于0 是否超出了集合本身的长度，然后再遍历集合 c 调用add方法，进	
 	行元素的添加，add方法在其子类实现，添加成功修改布尔值为true
	*/
    public boolean addAll(int index, Collection<? extends E> c) {
        rangeCheckForAdd(index);
        boolean modified = false;
        for (E e : c) {
            add(index++, e);
            modified = true;
        }
        return modified;
    }

	/*
	调用后面的内部类，Itr 实现了迭代器的接口，返回接口的实现类，这里应用了多态，Itr内部类在后面
	*/
    public Iterator<E> iterator() {
        return new Itr();
    }

	/*
	（空参数的迭代器的构造器）获取list特有的迭代器，传入一个以0开始的索引位置的迭代器
	*/
    public ListIterator<E> listIterator() {
        return listIterator(0);
    }

	/*
	（带有指定大小/索引的参数的构造器）先判断索引是否合理，然后再返回一个ListItr类，这个也是一个内部类，接下来说明
	*/
    public ListIterator<E> listIterator(final int index) {
        rangeCheckForAdd(index);

        return new ListItr(index);
    }



    private class Itr implements Iterator<E> {
        /*
        迭代表示当前索引的位置是在哪
         */
        int cursor = 0;

        /*
        因为迭代器的原理就是拿一次数据后就会向后移动，那就用这个参数来代表拿数据的具体的索引，所以后面就会形成lastRet比cursor前一位
         */
        int lastRet = -1;

        /*
        预期修改次数和实际修改次数
         */
        int expectedModCount = modCount;

		/*
		判断是否还有下一位，因为下面的next方法，拿数据就是吧cursor的值赋给 i ，所以可以知道cursor是代表索引，因为索引从0开始，而size从1开
		始，所以易知当两者相等时，结束遍历
		*/
        public boolean hasNext() {
            return cursor != size();
        }

		/*
		根据cursor的值调用get方法拿到值后，将此时的位置告诉lastRet，可以用lastRet来删除这个元素，然后sursor后移一位，代表迭代器已经向
		后移到了下个元素之间
		*/
        public E next() {
            checkForComodification();
            try {
                int i = cursor;
                E next = get(i);
                lastRet = i;
                cursor = i + 1;
                return next;
            } catch (IndexOutOfBoundsException e) {
                checkForComodification();
                throw new NoSuchElementException();
            }
        }

		/*
		删除元素，首先需要判断此时的记录 lastRet是否为-1 ，因为只有开始使用next后才不会为-1，也就是要删除某个位置的元素需要先经过next遍历
		然后才可以利用lastRet来删除，这里调用了remove方法，但是再次抽象类里面并未实现，因为ArrayList和LinkedList的增删查方式是不一样的，
		之后cursor索引位置回退，代表整个集合整合减少一位，lastRet回到-1（后面继续使用next方法，会再次附上拿值的位置）
		*/
        public void remove() {
            if (lastRet < 0)
                throw new IllegalStateException();
            checkForComodification();

            try {
                AbstractList.this.remove(lastRet);
                if (lastRet < cursor)
                    cursor--;
                lastRet = -1;
                expectedModCount = modCount;//迭代过程中，通过迭代器的remove方法删除列表元素时，不会抛出并发修改异常
                //这里涉及到并发修改产生的异常，猜测再Arraylist源码中会设计到这里的变量
            } catch (IndexOutOfBoundsException e) {
                throw new ConcurrentModificationException();
            }
        }
		
		//判断在迭代器生成之后，列表是否发生（不是通过迭代器做到的）结构性修改
        final void checkForComodification() {
            if (modCount != expectedModCount)
                throw new ConcurrentModificationException();
        }
    }


	/*
	List特有的迭代器，其实很容易理解，也就是在原先迭代器的基础上增加一个逆向遍历，还有增加迭代器的add方法，和set方法
	*/
    private class ListItr extends Itr implements ListIterator<E> {
    	//首先是一个构造方法，因为listIterator主要是来逆向遍历，也就是从后面遍历，但是也不一定要从最后面，可以从中间开始，
    	如果是从最后面开始的话，比如上面的lastIndex方法,查找最后一次出现指定数据的索引，传过来的就是size
        ListItr(int index) {
            cursor = index;
        }
		//判断是否有前一位数据，因为cursor是要来表示索引下标的，所以如果当传过来的index是0的话，就没有前一位了
        public boolean hasPrevious() {
            return cursor != 0;
        }
		//获取前一位数据，因为传过来的index表示的是从哪开始索引，比如传过来了一个size作为index，那这个时候就表示要从末尾开始向前遍历，那我
		们都知道size是要比索引后退一位的，因为从0开始，所以这里就要减-来开始索引，要是传过来了中间的索引，向前遍历也是要减一；然后lastRet还
		是一样用来记录下当前拿到的数据的位置，因为前面有减一操作，所以这里直接赋  i  给cursor，就和Iterator中有些不同  
        public E previous() {
            checkForComodification();
            try {
                int i = cursor - 1;
                E previous = get(i);
                lastRet = cursor = i;
                return previous;
            } catch (IndexOutOfBoundsException e) {
                checkForComodification();
                throw new NoSuchElementException();
            }
        }
		//获取当前拿到的数据的索引，这个方法在上面的lastIndex中有用到，其实名字是nextIndex但是拿到的索引还是刚刚获得的数据的，因为迭代器的	
		原理就是每拿到一个数据位置就移动，所以向前遍历自然就是拿到下一位的索引
        public int nextIndex() {
            return cursor;
        }
		//同理， 拿到前一位的索引，就是当前索引 - 1 ，ListIterator中的cursor和Iterator中的就表示了不同的位置了
        public int previousIndex() {
            return cursor-1;
        }
		//将当前数据替换掉，首先还是判断lastRet是否小于0，因为如果在这之前执行了remove操作的话，也就是把当前数据移除，那此时lastRet会回到
		-1，也就是不能进行替代操作了；然后后面还是调用了子类即将重写的set方法
        public void set(E e) {
            if (lastRet < 0)
                throw new IllegalStateException();
            checkForComodification();

            try {
                AbstractList.this.set(lastRet, e);
                expectedModCount = modCount;
            } catch (IndexOutOfBoundsException ex) {
                throw new ConcurrentModificationException();
            }
        }
		//添加元素，首先拿到数据，然后要往这个数据和前一个数据中间添加元素，其实也就是将即将要添加的元素放在当前数据的索引下，然后当前数据包括
		后面的数据全部向后移一位，那根据上面next中cursor表示的意义，即指向当前拿到的数据，那cursor理应向后移一位，也就是下一次遍历将拿到刚
		刚插入的数据，lastRet回到-1，下一次拿数据再次赋予 i 值；这里调用的方法还是子类即将重写的add 方法，利用索引添加元素  
        public void add(E e) {
            checkForComodification();

            try {
                int i = cursor;
                AbstractList.this.add(i, e);
                lastRet = -1;
                cursor = i + 1;
                expectedModCount = modCount;
            } catch (IndexOutOfBoundsException ex) {
                throw new ConcurrentModificationException();
            }
        }
    }

	/*
	这个方法的意思是返回当前集合的子集合，也就是如果现在有一个ArrayList，那调用这个方法，传入要从哪开始，到哪结束，也就是相当于获得中间一部分
	的子集合，如果当前集合中实现了RandomAccess接口，那会返回一个既基础当前抽象类又实现RandomAccess接口的子类
	RandomAcess是一个标识，表示支持随机访问，所谓随机访问也就是支持按索引查询中间数据，这个地方在我的AbstractCollection源码分析里有解析，
	以及有相关文章可参考
	*/
    public List<E> subList(int fromIndex, int toIndex) {
        return (this instanceof RandomAccess ?
                new RandomAccessSubList<>(this, fromIndex, toIndex) :
                new SubList<>(this, fromIndex, toIndex));
    }

	/*
	判断当前列表与指定对象是否相等，首先前两个是先判断地址是否相同，还有是否有继承list接口，如果没有就不用说了，后面是一个遍历，也就是判断两个
	对象的值是否相同，直到其中一个迭代器结束了，也就是前面元素都相同，那这个是时候还要判断两迭代器的长度是否一致，所以在return那里还要判断
	*/
    public boolean equals(Object o) {
        if (o == this)
            return true;
        if (!(o instanceof List))
            return false;

        ListIterator<E> e1 = listIterator();
        ListIterator<?> e2 = ((List<?>) o).listIterator();
        while (e1.hasNext() && e2.hasNext()) {
            E o1 = e1.next();
            Object o2 = e2.next();
            if (!(o1==null ? o2==null : o1.equals(o2)))
                return false;
        }
        return !(e1.hasNext() || e2.hasNext());
    }

	/*
	获取列表的哈希码值，首先是初始哈希码值为1，然后遍历集合，按照指定规则计算哈希码值，如果元素为null，则该元素的哈希码值为0，如果不为null
	则调用该元素获取其哈希码值，在Object中就有此描述，遍历完最终就得到当前列表的哈希码值
	*/
    public int hashCode() {
        int hashCode = 1;
        for (E e : this)
            hashCode = 31*hashCode + (e==null ? 0 : e.hashCode());
        return hashCode;
    }

	/*
	移除元素，从哪开始到哪结束，前面的clear就是调用这个方法实现的，首先是根据提供的list迭代器获取指定位置开始的迭代器，那在for循环条件里就
	可以指定循环的次数，然后就是利用next和移除的方法，一个一个进行操作
	*/
    protected void removeRange(int fromIndex, int toIndex) {
        ListIterator<E> it = listIterator(fromIndex);
        for (int i=0, n=toIndex-fromIndex; i<n; i++) {
            it.next();
            it.remove();
        }
    }

	//记录实际修改的次数，此处涉及到并发修改的问题，后续会补充详细其具体意义
    protected transient int modCount = 0;
	
	/*
	判断当前索引是否合理，如果小于0或者大于长度size则会抛出异常
	*/
    private void rangeCheckForAdd(int index) {
        if (index < 0 || index > size())
            throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
    }
	
	/*
	用来定义抛出异常的模板，即索引和当前size不合理
	*/
    private String outOfBoundsMsg(int index) {
        return "Index: "+index+", Size: "+size();
    }
}


/*
这是上面说到的子列表的类，里面的方法跟上面描述的是一样的，不一样的地方就在于这是一个头尾都被指定了的列表集合；其实它的内部原理并不是切割出了又一个列表，而是这个子列表每次操作的时候都是基于原来的列表的，只不过是索引上进行了改变而已，查看其构造方法就可知这个类是基于原列表和offset（索引变化）和size（新长度）进行的
*/
class SubList<E> extends AbstractList<E> {
    private final AbstractList<E> l;
    private final int offset;
    private int size;

    SubList(AbstractList<E> list, int fromIndex, int toIndex) {
        if (fromIndex < 0)
            throw new IndexOutOfBoundsException("fromIndex = " + fromIndex);
        if (toIndex > list.size())
            throw new IndexOutOfBoundsException("toIndex = " + toIndex);
        if (fromIndex > toIndex)
            throw new IllegalArgumentException("fromIndex(" + fromIndex +
                                               ") > toIndex(" + toIndex + ")");
        l = list;
        offset = fromIndex;
        size = toIndex - fromIndex;
        this.modCount = l.modCount;
    }

    public E set(int index, E element) {
        rangeCheck(index);
        checkForComodification();
        return l.set(index+offset, element);
    }

    public E get(int index) {
        rangeCheck(index);
        checkForComodification();
        return l.get(index+offset);
    }

    public int size() {
        checkForComodification();
        return size;
    }

    public void add(int index, E element) {
        rangeCheckForAdd(index);
        checkForComodification();
        l.add(index+offset, element);
        this.modCount = l.modCount;
        size++;
    }

    public E remove(int index) {
        rangeCheck(index);
        checkForComodification();
        E result = l.remove(index+offset);
        this.modCount = l.modCount;
        size--;
        return result;
    }

    protected void removeRange(int fromIndex, int toIndex) {
        checkForComodification();
        l.removeRange(fromIndex+offset, toIndex+offset);
        this.modCount = l.modCount;
        size -= (toIndex-fromIndex);
    }

    public boolean addAll(Collection<? extends E> c) {
        return addAll(size, c);
    }

    public boolean addAll(int index, Collection<? extends E> c) {
        rangeCheckForAdd(index);
        int cSize = c.size();
        if (cSize==0)
            return false;

        checkForComodification();
        l.addAll(offset+index, c);
        this.modCount = l.modCount;
        size += cSize;
        return true;
    }

    public Iterator<E> iterator() {
        return listIterator();
    }

    public ListIterator<E> listIterator(final int index) {
        checkForComodification();
        rangeCheckForAdd(index);

        return new ListIterator<E>() {
            private final ListIterator<E> i = l.listIterator(index+offset);

            public boolean hasNext() {
                return nextIndex() < size;
            }

            public E next() {
                if (hasNext())
                    return i.next();
                else
                    throw new NoSuchElementException();
            }

            public boolean hasPrevious() {
                return previousIndex() >= 0;
            }

            public E previous() {
                if (hasPrevious())
                    return i.previous();
                else
                    throw new NoSuchElementException();
            }

            public int nextIndex() {
                return i.nextIndex() - offset;
            }

            public int previousIndex() {
                return i.previousIndex() - offset;
            }

            public void remove() {
                i.remove();
                SubList.this.modCount = l.modCount;
                size--;
            }

            public void set(E e) {
                i.set(e);
            }

            public void add(E e) {
                i.add(e);
                SubList.this.modCount = l.modCount;
                size++;
            }
        };
    }

    public List<E> subList(int fromIndex, int toIndex) {
        return new SubList<>(this, fromIndex, toIndex);
    }

    private void rangeCheck(int index) {
        if (index < 0 || index >= size)
            throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
    }

    private void rangeCheckForAdd(int index) {
        if (index < 0 || index > size)
            throw new IndexOutOfBoundsException(outOfBoundsMsg(index));
    }

    private String outOfBoundsMsg(int index) {
        return "Index: "+index+", Size: "+size;
    }

    private void checkForComodification() {
        if (this.modCount != l.modCount)
            throw new ConcurrentModificationException();
    }
}


/*
这是上面提到的实现了RandomAccess接口的子列表所定义的类，其实也就是在上面SbList的基础上实现了接口，然后还是调用父类的构造方法，重写了父类子列表相关的subList方法，让其再次实现RandomAcess接口
*/
class RandomAccessSubList<E> extends SubList<E> implements RandomAccess {
    RandomAccessSubList(AbstractList<E> list, int fromIndex, int toIndex) {
        super(list, fromIndex, toIndex);
    }

    public List<E> subList(int fromIndex, int toIndex) {
        return new RandomAccessSubList<>(this, fromIndex, toIndex);
    }
}
```


